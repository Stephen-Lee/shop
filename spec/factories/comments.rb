FactoryGirl.define do
  factory :comment do
  	association :user
  	association :product
    content "MyText"
  end

end
