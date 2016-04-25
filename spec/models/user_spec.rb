# -*- encoding : utf-8 -*-
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:nick_name) }

  let(:user) {create :user}
  let(:payment_user) {create :payment_user}
  let(:admin) {create :admin}

  describe "payment password" do
     it "should not have payment password" do
       expect(user.payment_password).to eq(nil)
     end

     it "should have payment password" do
        expect(payment_user.payment_password).not_to eq(nil)
     end

     it "payment_password should equal 123456" do
       expect(payment_user.confirm_payment_password(123456)).to eq(true)
     end
  end

  describe "admin?" do
    it "should not be admin" do
      expect(user.has_role?(:admin)).to eq(false)
    end

    it "should be admin" do
      expect(admin.has_role?(:admin)).to eq(true)
    end
  end

  describe "user cart" do
    it "should have a cart" do
       expect(user.cart.nil?).to eq(false)
    end
  end

end
