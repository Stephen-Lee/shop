require 'rails_helper'

RSpec.describe Coupon, type: :model do
  it {should validate_presence_of(:verify_code)}
  it {should validate_presence_of(:value)}
  it {should validate_presence_of(:expire_at)}
 
  let(:user){create(:user)}
  let(:product){create(:product)}

  describe "use coupon" do
   before(:each) do
   	@coupon = Coupon.generate(10,user.id) #生成一张面值10元的优惠卷
    @order1 = Order.new(attributes_for(:order,user_id: user.id,verify_code: @coupon.verify_code))
    @order1.items.build(product_id: product.id)
    end

    it "should not expire" do
      expect(@coupon.expire_at > Time.now).to eq(true)
    end

    it "should use coupon" do
      @order1.save
      expect(@order1.total).to eq(40)
    end

    it "should delete coupon after save order" do
      @order1.save
      expect(user.coupons).not_to include(@coupon)
    end
  end
end
