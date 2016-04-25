# -*- encoding : utf-8 -*-
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	let(:user) {create :user}
    let(:user2){create :payment_user}

   describe ':edit' do
   it "should edit user" do
   	 sign_in user
     get :edit, id: user.id
     expect(response).to render_template :edit
   end
  end 

  describe "payment password" do
    it "should be valid" do
      sign_in user
      post :set_payment_password, id: user.id, user: attributes_for(:user,payment_password_handler: 234567,payment_password_handler_confirmation: 234567)
      expect(user.reload.confirm_payment_password(234567)).to eq(true)
    end

    it "should not be value while not confirm" do
      sign_in user
      post :set_payment_password, id: user.id, user: attributes_for(:user,payment_password_handler: 234567,payment_password_handler_confirmation: 123456)
      expect(user.reload.payment_password).to eq(nil)
    end

    it "should not be value while not number" do
      sign_in user
      post :set_payment_password, id: user.id, user: attributes_for(:user,payment_password_handler: "notnum",payment_password_handler_confirmation: "notnum")
      expect(user.reload.payment_password).to eq(nil)
    end

    it "should not valid while not 6 character" do
      sign_in user
      post :set_payment_password, id: user.id, user: attributes_for(:user,payment_password_handler: 1234567,payment_password_handler_confirmation: 1234567)
      expect(user.reload.payment_password).to eq(nil)
    end

    it "should not valid while update without old password" do
      sign_in user2
      patch :update_payment_password, id: user2.id, user: attributes_for(:user,payment_password_handler: 345678,payment_password_handler_confirmation: 345678)
      expect(user2.reload.confirm_payment_password(345678)).to eq(false)
    end

    it "should not valid while have wrong old password" do
      sign_in user2
      patch :update_payment_password, id: user2.id, user: attributes_for(:user,old_payment_password: 123789,payment_password_handler: 345678,payment_password_handler_confirmation: 345678)
      expect(user2.reload.confirm_payment_password(345678)).to eq(false)
    end

    it "should valid while have old_payment_password" do
      sign_in user2
      patch :update_payment_password, id: user2.id, user: attributes_for(:user,old_payment_password: 123456,payment_password_handler: 345678,payment_password_handler_confirmation: 345678)
      expect(user2.reload.confirm_payment_password(345678)).to eq(true)
    end
  
  end

 describe "update" do
   it "should update" do
     sign_in user
     patch :update, id: user.id, user: attributes_for(:user,age: 18)
     user.reload
     expect(user.age).to eq(18)
   end
 
 end

  
end
