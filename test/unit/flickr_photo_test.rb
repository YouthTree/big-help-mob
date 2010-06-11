require 'test_helper'

class FlickrPhotoTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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