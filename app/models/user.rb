# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  include BCrypt
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :old_payment_password,:payment_password_handler

  has_one :cart, dependent: :destroy
  has_many :orders
  has_many :marks, dependent: :destroy
  has_many :mark_products, through: :marks, source: :product
  has_many :comments
  has_many :authorities, dependent: :destroy
  has_many :roles, through: :authorities
  has_many :coupons, dependent: :destroy
  has_many :award_items, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, :omniauth_providers => [:github,:twitter,:facebook]

  validates :nick_name, presence: true, length: {minimum: 2, maximum: 15},
    uniqueness: {case_sensitive: false}

  validates :payment_password_handler,length: {is: 6},
    numericality: {only_integer: true},confirmation: true,:if => :payment_password_exist?
  validates :payment_password_handler_confirmation,presence: true, :if => :payment_password_exist?

  before_save :bcrypt_payment_password
  before_create :set_test_money
  after_create :create_cart


  def payment_password_exist?
    !payment_password_handler.nil?
  end

  def bcrypt_payment_password
    if self.payment_password_handler
       self.payment_password = Password.create(self.payment_password_handler)
    end
  end

  def set_test_money
    self.money = 1000
  end

  def create_cart
    Cart.create(user_id: self.id)
  end


  def confirm_payment_password(password)
    Password.new(payment_password) == password
  end
 
 
  def check_avatar
    if avatar.blank?
      "default_avatar.jpg"
    else
      avatar
    end
  end

  def has_role?(role)
    if roles.find_by_name(role)
      true
    else
      false
    end
  end


  def ban_comment(ban_time)
    update_attributes(ban_comment_until: (Time.now + ban_time))
  end

  Super_admin = ["admin@admin.com"]
  def super_admin?
    Super_admin.include?(email)
  end

  def marking?(product)
    marks.find_by_product_id(product)
  end

  def unmarked!(mark_product)
    marks.find_by_product_id(mark_product).destroy
  end


  def self.from_omniauth(auth_hash)
    user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
    user.nick_name = auth_hash['info']['name']
    user.email = auth_hash['info']['email'] || "#{user.uid}@sshop.com"
    user.password = Devise.friendly_token[0,12]
    #user.location = auth_hash['info']['location']
    user.remote_avatar_url = auth_hash['info']['image']
    user.save!
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      elsif data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      elsif data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
