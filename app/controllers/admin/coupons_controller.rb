class Admin::CouponsController < Admin::BaseController
  def index
    @coupons = Coupon.where(user_id: nil).order('created_at DESC')
  end

  def create
    (params[:quantity].to_i).times {Coupon.generate(params[:value])}
    redirect_to admin_coupons_path
  end
end
