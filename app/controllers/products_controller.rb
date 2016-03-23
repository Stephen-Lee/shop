# -*- encoding : utf-8 -*-
class ProductsController < ApplicationController

  load_and_authorize_resource
  def index
    @products = Product.all.order("created_at desc")
    @hot_sales = Product.where.not(sales: 0).order("sales desc").limit(10)
    @banners = Banner.all.order("created_at DESC")
  end

  def show
    @product = Product.find(params[:id])
    @comments = @product.comments.order("created_at DESC").limit(10)
  end


  def search
    @products = Product.where("name LIKE ?", params[:query])
  end

  def high_grade_search

  end
end
