# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :product do
    sequence(:name) {|n| "product#{n}"}
    price 50
    inventory 500
    introduction "Text"
    sales 0
  end

  factory :product_with_type,parent: :product do
   type_list ["small","big"]
  end
end
