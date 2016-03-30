# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  include BCrypt

  before_action :authenticate_user!
  before_action :authenticate_old_payment_password, only: :update_payment_password
  load_and_authorize_resource

  def show
  end

  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      flash[:notice] = "完成更新"
      redirect_to root_path
    else
      flash[:alert] = "更新失败"
      render 'edit'
    end
  end

  def set_payment_password
    if current_user.update_attributes(payment_params)
      flash[:notice] = "更新成功"
      redirect_to edit_user_path(current_user)
    else
      flash[:notice] = "密码不符合要求"
      render 'edit'
    end

  end

  def update_payment_password

    if current_user.update_attributes(payment_params)
      flash[:notice] = "更新成功"
      redirect_to edit_user_path(current_user)
    else
      flash[:notice] = "密码不符合要求"
      render 'edit'
    end
  end

  def destroy
  end


  private
  def user_params
    params.require(:user).permit(:avatar,:real_name,:phone,:address,
                                 :sex,:age,:s_province,:s_city,:s_county)
  end

  def payment_params
    params.require(:user).permit(:old_payment_password,:payment_password_handler,:payment_password_handler_confirmation)
  end

  def authenticate_old_payment_password
    unless current_user.confirm_payment_password(params[:user][:old_payment_password])
      flash[:notice] = "旧支付密码错误"
      render 'edit'
    end
  end

end
