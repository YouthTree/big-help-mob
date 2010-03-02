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
    #errors.add(:address, "Could not Geocode address") if !geo.success     NB: For now, don't fail if it can't geocode, we just won't include a map :-)
    self.lat, self.lng = geo.lat,geo.lng if geo.success
  end

  # Model methods

end
