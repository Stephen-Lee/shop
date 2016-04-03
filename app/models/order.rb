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
  before_create :set_default_status

  after_create :handle_job

  def handle_job
    OrderHandlerJob.set(wait: 1.weeks).perform_later(self)
  end

  def build_items(selected_items)
    selected_items.each do |i|
      if i[:product_id]
         self.items.build(product_id: i[:product_id],
                         quantity: i[:quantity],
                         product_type: i[:product_type])
    
      end
    end
  end

  def not_paid?
    self.status == "not_paid"
  end

  def pay_by(user)
    user.update_attributes(money: user.money - self.total)
    self.update_attributes(status: "paid")

    increment_sales_counter
    update_inventory
    delete_cart_items
  end

  def update_user_score
     user = self.user
     user.update_attributes(score: user.score + self.total) 
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


  def set_default_status
     self.status = "not_paid"
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


  def delete_cart_items
    cart_items = user.cart.items
    self.items.each do |i|
      type = i.product_type.blank? ? nil : i.product_type
      cart_items.where(product_id: i.product_id,product_type: type).destroy_all
    end
  end
end
