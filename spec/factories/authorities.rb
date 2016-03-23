FactoryGirl.define do
  factory :authority do
    association :user
    association :role
  end

end
