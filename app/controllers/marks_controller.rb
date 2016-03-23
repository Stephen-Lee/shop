class MarksController < ApplicationController
  load_and_authorize_resource only: :index
  before_action :authenticate_user!
  def index
    @mark_products = current_user.mark_products.paginate(page: params[:page], per_page: 5)
  end

  def create
    @product = Product.find(params[:mark][:product_id])
    current_user.marks.create!(product_id: @product.id)
    respond_to do |format|
      format.html {redirect_to @product}
      format.js
    end
  end

  #在商品页面取消收藏
  def destroy
    @product = Mark.find(params[:id]).product
    current_user.unmarked!(@product)
    respond_to do |format|
      format.html {redirect_to @product}
      format.js
    end
  end

  #在收藏清单页移除商品
  def remove
    @product = Product.find(params[:id])
    @mark_products = current_user.mark_products.paginate(page: params[:page], per_page: 5)
    current_user.unmarked!(@product)
    respond_to do |format|
      format.html {redirect_to marks_path}
      format.js
    end
  end
end
