# -*- encoding : utf-8 -*-
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	let(:user) {create :user}


   describe ':edit' do
   it "should edit user" do
   	 sign_in user
     get :edit, id: user.id
     expect(response).to render_template :edit
   end
  end 

  
end
