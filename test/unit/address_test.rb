require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  
  should_validate_presence_of     :street1, :city, :state, :postcode, :country, :message => "must be filled in to continue"
  should_allow_mass_assignment_of :street1, :street2, :city, :state, :postcode, :country
  
end

# == Schema Info
#
# Table name: addresses
#
#  id               :integer(4)      not null, primary key
#  addressable_id   :integer(4)
#  addressable_type :string(255)
#  city             :string(255)
#  country          :string(255)
#  lat              :decimal(15, 10)
#  lng              :decimal(15, 10)
#  postcode         :string(255)
#  state            :string(255)
#  street1          :string(255)
#  street2          :string(255)
#  created_at       :datetime
#  updated_at       :datetime