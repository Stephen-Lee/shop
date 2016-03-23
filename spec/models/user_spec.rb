# -*- encoding : utf-8 -*-
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:nick_name) }

  let(:user) {create :user}
  let(:admin) {create :admin}

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
