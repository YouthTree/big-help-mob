require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  
  should_validate_presence_of     :street1, :city, :state, :country, :message => "must be filled in to continue"
  should_allow_mass_assignment_of :street1, :street2, :city, :state, :postcode, :country
  
  should_belong_to :addressable
  
  should 'let you convert it to a lat lng pair' do
    
  end
  
  should 'automatically attempt to geocode the address'
  
  should 'let you lookup the associated country name' do
    address = Address.make(:country => "AU")
    assert_equal "Australia", address.country_name
  end
  
  should 'let you get a nice string representation' do
    address = Address.make(:street1 => "100 Awesome Avenue", :street2 => nil, :country => "AU", :state => "Western Australia", :postcode => 6000, :city => "Perth")
    assert_equal "100 Awesome Avenue, Perth, Western Australia 6000, Australia", address.to_s
  end
  
  should 'let you specify the string joiner' do
    address = Address.make(:street1 => "100 Awesome Avenue", :street2 => nil, :country => "AU", :state => "Western Australia", :postcode => 6000, :city => "Perth")
    assert_equal "100 Awesome Avenue\nPerth\nWestern Australia 6000\nAustralia", address.to_s("\n")
  end
  
  should 'let you check if it is for a user' do
    a, b = Address.make(:addressable => Address.make), Address.make(:addressable => User.make)
    assert !a.for_user?
    assert b.for_user?
    b.addressable = nil
    a.addressable = nil
    assert !a.for_user?
    assert !b.for_user?
  end
  
  should 'be pending' do
    fail "lulz"
  end
  
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