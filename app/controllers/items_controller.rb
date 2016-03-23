class ItemsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource


  def destroy
    @item = Item.find(params[:id])
    @item.delete
    respond_to do |format|
      format.html{redirect_to current_user.cart}
    end
  end

end
