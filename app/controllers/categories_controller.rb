class CategoriesController < ApplicationController
  load_and_authorize_resource
  def show
    @category = Category.find(params[:id])
    @products = @category.products.order("created_at desc")
  end
end
