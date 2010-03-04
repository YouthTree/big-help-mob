require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  
  should_validate_presence_of     :street1, :city, :state, :postcode, :country
  should_allow_mass_assignment_of :street1, :street2, :city, :state, :postcode, :country
  
end
