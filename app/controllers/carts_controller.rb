class CartsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  def show
    @items = current_user.cart.items.includes(:product).paginate(page: params[:page], per_page: 5).order('created_at DESC')
  end

  def add_item
    item_params = params[:items][0]
    @item = current_user.cart.items.build(product_id: item_params[:product_id],
      quantity: item_params[:quantity],product_type: item_params[:product_type])
    respond_to do |format|
      if @item.save
        format.html {redirect_to @item.product,notice: "成功加入购物车"}
      else
        format.html{redirect_to @item.product,alert: "未指定商品种类！"}
      end
    end
  end

  def destroy
    @items = current_user.cart.items.all
    @items.delete_all
    redirect_to cart_path(current_user.cart)
  end
end
