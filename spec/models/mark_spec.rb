require 'rails_helper'

RSpec.describe Mark, type: :model do
  
  let(:user){create(:user)}
  let(:product){create(:product)}
  describe "marking" do
   
    it "should mark product" do
       user.marks.create(product_id: product.id)
       expect(user.mark_products).to include(product)
    end

    it "should destroy mark_products" do 
       user.marks.create(product_id: product.id)
       user.unmarked!(product.id)
       expect(user.mark_products).not_to include(product)
    end
  end
end
