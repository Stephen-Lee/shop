require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
let(:user){create :user}
let(:order){create :order, user: user}
let(:product){create :product}
 before(:each) do
  sign_in user
 end

describe 'index' do
 it "should get index" do
  get :index
  expect(response).to be_success 
 end 
end


 
end
