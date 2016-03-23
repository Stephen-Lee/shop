class Admin::BaseController < ApplicationController
  before_action :ensure_admin
  layout 'admin'
  private

  def ensure_admin
    redirect_to root_path unless current_user.has_role?(:admin)
  end
end
