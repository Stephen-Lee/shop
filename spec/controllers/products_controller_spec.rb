# -*- encoding : utf-8 -*-
require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
 let(:product) {create :product}

  describe ':index' do
  it "should get index" do
   get :index
   expect(response).to be_success
  end
  end

  describe ':show' do
  it "should get show" do
  get :show, id: product.id
  expect(response).to be_success
  end
  end
  
  
end
