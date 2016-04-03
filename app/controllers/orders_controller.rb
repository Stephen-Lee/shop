class OrdersController < ApplicationController

  before_action :authenticate_user!
  before_action :check_type,only: :preview
  before_action :insure_not_paid, only: [:payment,:paid]
  before_action :authenticate_password, only: :paid
  before_action :insure_enough_money, only: :paid

  after_action :update_score, only: :confirm
  load_and_authorize_resource except: :preview

  def index
    @orders = current_user.orders.includes(:products,:items).paginate(page: params[:page], per_page: 5).order('created_at DESC')
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def preview
    if params[:commit] == "加入购物车"
      redirect_to add_item_carts_path(items: params[:items])
    end
    @order = current_user.orders.build
    @order.build_items(params[:items])
  end

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      redirect_to payment_order_path(@order)
    else
      flash[:notice] = "提交订单失败"
      render 'preview'
    end
  end

  def payment
  end

  def paid
    @order.pay_by(current_user)
    redirect_to orders_path
  end

  def confirm
    @order = Order.find(params[:id])
    @order.update_attributes(status: "confirm")
    respond_to do |format|
      format.js
    end
  end

  private
  def order_params
    params.require(:order).permit(:buyer,:phone,:address,:user_id,:verify_code,
                                  items_attributes: [:product_id,:quantity,:product_type]
                                  )
  end

  def check_type
    params[:items].each do |item|
      if item[:product_type].blank?
        @product = Product.find(item[:product_id])
        if @product.type_list.any?
          flash[:notice] = "你未指定类型"
          redirect_to @product
        end
      end
    end
  end

  def insure_not_paid
    @order = current_user.orders.find(params[:id])
    unless @order.not_paid?
      flash[:notice] = "该订单已完成或关闭"
      redirect_to orders_path
    end
  end
  
  def authenticate_password
    unless current_user.confirm_payment_password(params[:payment_password])
      flash[:alert] = "支付密码错误"
      render 'payment'
    end
  end

  def insure_enough_money
    unless current_user.money >= @order.total
      flash[:alert] = "账号余额不足！"
      render 'payment'
    end
  end

  def update_score
     @order.update_user_score
  end
end
