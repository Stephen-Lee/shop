class CommentsController < ApplicationController
  load_and_authorize_resource except: [:ban,:all]
  before_action :authenticate_user!, except:  :all
  before_action :insure_can_comment, only: :create

  def create
    @product = Product.find(params[:product_id])
    @comment = @product.comments.build(comment_params)
    if @comment.save
      respond_to do |format|
        format.js
        format.html{redirect_to @product}
      end
    end

  end

  def all
    @product = Product.find(params[:id])
    @comments = @product.comments.includes(:user).paginate(page: params[:page], per_page: 10).order('created_at DESC')
  end


  def ban
    @user = User.find(params[:id])
    ban_time = params[:ban_time].to_i.hours
    @user.ban_comment(ban_time)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.delete
      respond_to do |format|
        format.html {redirect_to product_path(@comment.product)}
        format.js
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:user_id,:content,:commentable_type,:commentable_id)
  end

  def insure_can_comment
    redirect_to product_path(params[:product_id]) unless current_user.ban_comment_until.nil? || Time.now > current_user.ban_comment_until
  end

end
