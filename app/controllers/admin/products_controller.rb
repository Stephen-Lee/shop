class Admin::ProductsController < Admin::BaseController
  #before_action :destroy_suggestions, only: :destroy  #not for heroku
  def index
    @products = Product.all#.paginate(page: params[:page], per_page: 30).order("created_at desc")
  end

  def new
    @product = Product.new
    @selectable_categories = Category.where.not(ancestry: 0)
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "创建成功"
    else
      flash[:notice] = "出错啦！"
    end
    redirect_to admin_products_path
  end

  def edit
    @product = Product.find(params[:id])
    @selectable_categories = Category.where.not(ancestry: 0)
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      flash[:notice] = "update successful"
    else
      flash[:notice] = "failed!"
    end
    redirect_to admin_products_path
  end

  def destroy
    if @product.delete
      flash[:notice] = "删除成功"
    else
      flash[:notice] = "出错啦！"
    end
    redirect_to admin_products_path
  end


  private
  def product_params
    params.require(:product).permit(:name,:price,:inventory,:picture,
                                    :introduction, :category_id,{type_list: []}) 
  end
  
  def destroy_suggestions
    @product = Product.find(params[:id])
    @product.remove_suggestions
  end
end
