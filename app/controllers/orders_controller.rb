class OrdersController < ApplicationController

  before_action :authenticate_user!
  before_action :check_type,only: :preview
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
    @order = current_user.orders.find(params[:id])
  end

  def paid
    @order = current_user.orders.find(params[:id])
    if current_user.confirm_payment_password(params[:payment_password]) 
    redirect_to orders_path
    else
      flash[:notice] = "支付密码错误"
      redirect_to payment_order_path(@order)
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

end
