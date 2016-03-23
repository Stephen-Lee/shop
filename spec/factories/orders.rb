FactoryGirl.define do
  factory :order do
    association :user
    buyer "Jack Ma"
    phone "10086"
    address "small street"
  end

end
