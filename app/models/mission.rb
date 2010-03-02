class Mission < ActiveRecord::Base
  
  # Validations
  validates_presence_of :name, :on => :create, :message => "can't be blank"

  # Associations
  
  # Geocoding
  
  acts_as_mappable
  apply_addresslogic

  before_save :geocode_address

  def geocode_address
    return unless address.changed?
    geo = Geokit::Geocoders::MultiGeocoder.geocode(address.address_parts.join(", "))
    self.lat, self.lng = geo.lat, geo.lng if geo.success
  end

  # Model methods

end
