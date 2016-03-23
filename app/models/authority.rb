class Authority < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  validates :user_id, uniqueness: true
end
