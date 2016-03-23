class Banner < ActiveRecord::Base
validates :picture, presence: true
validates :url,presence: true

mount_uploader :picture, PictureUploader
end
