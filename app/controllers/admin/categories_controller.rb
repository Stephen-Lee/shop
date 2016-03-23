class Admin::CategoriesController < Admin::BaseController
  def index
    @categories = Category.where(ancestry: nil)
  end

  def show
    @category = Category.find(params[:id])
    @category_childs = @category.children
  end

  def create
    @category = Category.new(category_params)
    @category.save
    redirect_to admin_categories_path
  end


  def destroy
    @category = Category.find(params[:id])
    @category.children.destroy_all
    @category.delete
    redirect_to admin_categories_path
  end

  private
  def category_params
    params.require(:category).permit(:name, :ancestry)
  end
end
