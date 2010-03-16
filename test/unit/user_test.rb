require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
end

# == Schema Info
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  admin             :boolean(1)
#  allergies         :text
#  crypted_password  :string(255)
#  current_login_ip  :string(255)
#  date_of_birth     :date
#  display_name      :string(255)
#  email             :string(255)
#  first_name        :string(255)
#  last_login_ip     :string(255)
#  last_name         :string(255)
#  login             :string(255)
#  login_count       :integer(4)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  phone             :string(255)
#  postcode          :integer(4)
#  created_at        :datetime
#  current_login_at  :datetime
#  last_login_at     :datetime
#  last_request_at   :datetime
#  updated_at        :datetime