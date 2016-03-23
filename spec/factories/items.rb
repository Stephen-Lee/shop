FactoryGirl.define do
  factory :item do
    association :product
    quantity 1
    product_type ""
    total 0
  end

  factory :cart_item,parent: :item do
    association :cart
  end

  factory :order_item,parent: :item do
    association :order
  end

end
