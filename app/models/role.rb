class Role < ActiveRecord::Base
  has_many :authorities, dependent: :destroy
  has_many :users, through: :authorities

  validates :name, presence: true,uniqueness: true
end
