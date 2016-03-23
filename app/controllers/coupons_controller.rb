class CouponsController < ApplicationController
  def index
    @coupons = current_user.coupons.where('expire_at > ?',Time.now).order("value DESC")
  end
end
