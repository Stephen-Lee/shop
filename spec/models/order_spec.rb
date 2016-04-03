require 'rails_helper'

RSpec.describe Order, type: :model do
  it {should validate_presence_of(:buyer)}
  it {should validate_presence_of(:phone)}
  it {should validate_presence_of(:address)}

  let(:user){create(:user)}
  let(:order) {create(:order)}
  let(:product){create(:product)}
  let(:product_with_type){create(:product_with_type)}
  
  before(:each) do
    @item = user.cart.items.create(product_id: product.id)
    @order1 = Order.new(attributes_for(:order,user_id: user.id))
    @order1.items.build(product_id: product.id,quantity: 20)
    @order1.items.build(product_id: product_with_type.id,quantity: 10,product_type: product_with_type.type_list[0])
    @order1.save
  end

  describe "build order" do
    it "can't build when item quantity more than inventory" do
      order.items.build(product_id: product.id,quantity: 501)
      expect(order.valid?).to eq(false)
    end

    it "should no build when no product_type specific" do
       order.items.build(product_id: product_with_type.id)
       expect(order.valid?).to eq(false)
    end
    
    it "should calculate the total" do
      expect(@order1.items[0].total).to eq(10000)
      expect(@order1.total).to eq(15000)
    end

  end

  describe "after create order" do  
    it "should have status not_paid" do
        expect(@order1.status).to eq("not_paid")
    end

    it "user should still have 20000 yuan"do
        expect(user.money).to eq(20000)
    end 
  end

  describe "after paid" do
    before(:each) do
      @order1.pay_by(user)
    end
  
    it "user should have 5000 yuan" do
      expect(user.money).to eq(5000)
    end

    it "should update product inventory" do
       expect(@order1.products.first.inventory).to eq(480)
       expect(@order1.products.second.inventory).to eq(490)
    end

    it "should update product sales" do
       expect(@order1.products.first.sales).to eq(20)
       expect(@order1.products.second.sales).to eq(10)
    end

    it "should delete cart item" do
       expect(@order1.user.cart.items).not_to include(@item)
    end
  end
end
