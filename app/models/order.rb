class Order < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :products, through: :items
  accepts_nested_attributes_for :items

  attr_accessor :verify_code
  validates :buyer, presence: true, length: {minimum: 2, maximum: 20}
  validates :phone, presence: true, length: {minimum: 5, maximum: 15}
  validates :address, presence: true, length: {maximum: 60}
  validates :user_id, presence: true
  
  before_create :calculate_item_total
  before_create :calculate_order_total
  before_create :check_coupon

  after_create :increment_sales_counter
  after_create :update_inventory
  after_create :update_user_score
  after_create :delete_cart_items


  def build_items(selected_items)
    selected_items.each do |i|
      if i[:product_id]
         self.items.build(product_id: i[:product_id],
                         quantity: i[:quantity],
                         product_type: i[:product_type])
    
      end
    end
  end

  private

  def calculate_item_total  #计算各个item的合计价
    self.items.each do |item|
      product = Product.find(item.product_id)
      item.total = item.quantity * product.price
    end
  end

  def calculate_order_total  #计算订单总价
    self.total = 0
    self.items.map {|i| self.total += i.total}
  end


  def check_coupon
    if !self.verify_code.blank?
      coupon = Coupon.find_by_verify_code(self.verify_code)
      if coupon && coupon.expire_at > Time.now
        if self.total - coupon.value < 0
          self.total == 0
        else
          self.total -= coupon.value
        end
        coupon.delete
      end
    end
  end


  def increment_sales_counter
    self.items.map { |i| i.product.update_attributes(sales: i.product.sales + i.quantity) }
  end


  def update_inventory  #更新库存
    self.items.each do |i|
      p = i.product
      p.update_attributes(inventory: p.inventory - i.quantity)
    end
  end

  def update_user_score
     user = self.user
     user.update_attributes(score: user.score + self.total) 
  end

  def delete_cart_items
    cart_items = user.cart.items
    self.items.each do |i|
      type = i.product_type.blank? ? nil : i.product_type
      cart_items.where(product_id: i.product_id,product_type: type).destroy_all
    end
  end
end
