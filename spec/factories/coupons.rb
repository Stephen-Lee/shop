FactoryGirl.define do
  factory :coupon do
    verify_code "12345"
    value 10
    association :user
    expire_at Time.now + 1.days
  end

end
