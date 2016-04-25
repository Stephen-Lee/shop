# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :user do
    sequence(:nick_name){|n| "man#{n}"}
    sequence(:email){|n| "#{n}@qq.com"}
    password "123456"
    password_confirmation "123456"
    address "xx street"
    phone "16060606060"
    real_name "Mike"
  end

  factory :admin,parent: :user do
    roles {[create(:admin_role)]}
  end
  
  factory :payment_user,parent: :user do
    payment_password_handler 123456
    payment_password_handler_confirmation 123456
  end
end
