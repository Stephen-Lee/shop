# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit,:update]
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



  def destroy
  end

  private
  def user_params
    params.require(:user).permit(:avatar,:real_name,:phone,:address,
                                 :sex,:age,:s_province,:s_city,:s_county)
  end
end
