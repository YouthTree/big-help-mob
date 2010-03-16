class Address < ActiveRecord::Base
  attr_accessible :street1, :street2, :city, :state, :postcode, :country
  
  belongs_to :addressable, :polymorphic => true
  
  validates_presence_of :street1, :city, :state, :postcode, :country
  
  apply_addresslogic :fields => [:street1, :street2, :city, [:state, :postcode], :country]
  
  acts_as_mappable :default_units => :kms
  
  before_save :geocode

  def geocode
    return unless changed?
    geo = Geokit::Geocoders::MultiGeocoder.geocode(self.to_s(", "))
    self.lat, self.lng = geo.lat, geo.lng if geo.success
    return self.lat, self.lng
  end
  
  def to_lat_lng
    [self.lat, self.lng]
  end
  
  def to_s(joiner = ", ")
    address_parts.join(joiner)
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