require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart){create(:cart)}
  let(:cart_item){create(:cart_item)}
  let(:product_with_type){create(:product_with_type)}
  let(:product){create(:product)}

  describe "cart operate" do
  
    it "should not add to cart without product_type" do
       item = cart.items.build(product_id: product_with_type.id)
       expect(item.valid?).to eq(false)
    end

    it "should add to cart when specific type" do
      item = cart.items.build(product_id: product_with_type.id,product_type: product_with_type.type_list[0])
      expect(item.valid?).to eq(true)
    end

    it "should add to cart when product no type" do 
      item = cart.items.build(product_id: product.id)
      expect(item.valid?).to eq(true)
    end
    
    it "should delete item" do
      cart_item.delete
      expect(cart_item.cart.items).not_to include(cart_item)
    end
   
  end
end
