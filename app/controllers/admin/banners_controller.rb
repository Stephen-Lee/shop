class Admin::BannersController < ApplicationController
  def create
  	@banner = Banner.new(banner_params)
  	respond_to do |format|
      if @banner.save
      	format.js
      end
  	end
  end

  def update
  	@banner = Banner.find(params[:id])
  	respond_to do |format|
  	  if @banner.update_attributes(banner_params)
  	  		format.js
  	  end	
    end
  end

  def destroy
  	@banner = Banner.find(params[:id])
  	respond_to do |format|
      if @banner.delete
      	format.js
      end
  	end
  end

  private
  def banner_params
  	params.require(:banner).permit(:url,:picture)
  end
end
