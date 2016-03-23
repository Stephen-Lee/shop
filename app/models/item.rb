class Item < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  belongs_to :order

  validates :quantity, presence: true,
    numericality: {only_integer: true, greater_than_or_equal_to: 0,
                   less_than_or_equal_to: :product_inventory}
  validates :product_id, presence: true
  validate :check_product_type
  

  def product_inventory
    self.product.inventory
  end


  def check_product_type
    if self.product_type.nil?
      if self.product.type_list.any?
        errors.add(:product, "you need to specific product type!")
      end
    end
  end
end
