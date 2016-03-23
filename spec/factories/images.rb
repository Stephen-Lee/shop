FactoryGirl.define do
  factory :image do
    sequence(:url) {|n| "image#{n}.jpg"}
  end
  
end
