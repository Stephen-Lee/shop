# -*- encoding : utf-8 -*-
require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price)}
  it { should validate_presence_of(:inventory)}
  
end
