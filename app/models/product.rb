# -*- encoding : utf-8 -*-
class Product < ActiveRecord::Base
  acts_as_taggable_on :types

  has_many :items, dependent: :destroy
  has_many :orders, through: :items, dependent: :destroy
  belongs_to :category
  has_many :marks, dependent: :destroy
  has_many :marking_users, through: :marks, source: :user
  has_many :preview_images, as: :imageable,class_name: "Image", dependent: :destroy
  has_many :comments, as: :commentable,dependent: :destroy
  mount_uploader :picture, PictureUploader


  validates :name, presence: true, length: {maximum: 50},uniqueness: {case_sensitive: false}
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :inventory, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  before_save :handle_type_list
  #after_save :add_to_suggestions  #not for heroku

  #before_update :remove_suggestions #not for heroku
 

  def handle_type_list
   self.type_list = type_list[0].to_s.gsub(/ /,",")
  end
  
  def add_to_suggestions
     AutoSearch.add_product_term(self.id)
  end

  def remove_suggestions
    AutoSearch.remove_product_term(self.id)
  end
end
