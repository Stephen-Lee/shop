class Admin::UsersController < Admin::BaseController
  before_action :insure_super_admin, only: [:add, :remove]

  def index
    @users = User.all
    @admin_users = Role.find_by_name("admin").users
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:notice] = "update successful"
    else
      flash[:notice] = "failed!"
    end
    redirect_to admin_users_path
  end

  def add
    @user = User.find_by_email(params[:email])
    if @user.authorities.create!(role_id: 1)
      flash[:notice] = "添加成功"
    else
      flash[:notice] = "出现错误！"
    end
    redirect_to admin_users_path
  end

  def remove
    @user = User.find(params[:id])
    @user.authorities.find_by_role_id(1).delete unless @user.super_admin?
    redirect_to admin_users_path
  end

  def destroy
  end

  private
  def user_params
    params.require(:user).permit(:nick_name,:real_name, :phone, :address)
  end

  def insure_super_admin
    redirect_to admin_users_path unless current_user.super_admin?
  end
end
