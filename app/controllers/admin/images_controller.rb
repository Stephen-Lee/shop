class Admin::ImagesController < ApplicationController

  def create
    respond_to do |format|
      @product = Product.find(params[:image][:imageable_id])
      @image = @product.preview_images.build(image_params)
      if @product.preview_images.count >= 5
        @error = true
        format.js 
      elsif @image.save
        format.js
      end
    end
  end

  def del_image
    @image = Image.find(params[:image_id])
    respond_to do |format|
      if @image.delete
        format.js
      end
    end

  end

  private

  def image_params
    params.require(:image).permit(:url,:imageable_id)
  end
end
