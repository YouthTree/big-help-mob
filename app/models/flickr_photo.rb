class FlickrPhoto < ActiveRecord::Base
end


# == Schema Info
#
# Table name: flickr_photos
#
#  id         :integer(4)      not null, primary key
#  flickr_id  :string(255)
#  farm       :integer(4)
#  isprimary  :string(255)
#  secret     :string(255)
#  server     :string(255)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime