class Ability
  include CanCan::Ability

  def initialize(user)
    basic_function

    if !user.blank?
      signed_in_function

      if user.has_role?("admin")
        can :manage, :all
      end
    end

  end

  private
  def basic_function
    can [:read, :detail, :search, :high_grade_search], Product
    can [:index, :all], Comment
    can :read, Category
  end

  def signed_in_function
    can [:edit,:update,:set_payment_password,:update_payment_password], User
    can [:read, :preview,:create, :payment,:paid,:confirm], Order
    can [:index, :create, :destroy, :remove], Mark
    can :destroy, Item
    can :create, Comment
    can [:show,:add_item,:destroy], Cart
  end

end
