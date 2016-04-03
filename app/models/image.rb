class Image < ActiveRecord::Base
	belongs_to :imageable, polymorphic: true
 
	mount_uploader :url, PictureUploader
 
    validates :url,presence: true
	
end
