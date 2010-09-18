## Representation of a postal/physical address.
#
# Saves latitude and longitude for address using Geokit.
#
class Address < ActiveRecord::Base
  attr_accessible :street1, :street2, :city, :state, :postcode, :country
  
  belongs_to :addressable, :polymorphic => true
  
  validates_presence_of :street1, :city, :state, :country
  validates_presence_of :postcode, :if => :for_user?
  
  apply_addresslogic :fields => [:street1, :street2, :city, [:state, :postcode], :country_name]
  
  before_save :geocode

  ## Obtain the latitude and longitude from the relevant geo provider
  # @return [Array] Latitude and longitude
  # TODO: This has no resilience, if geocode craps out how do we handle it?
  def geocode
    return unless changed?
    geo = Geokit::Geocoders::MultiGeocoder.geocode(self.to_s(", "))
    self.lat, self.lng = geo.lat, geo.lng if geo.success
    return self.lat, self.lng
  end
  
  ## Return latitude and longitude as array
  # @return [Array] Latitude and longitude
  def to_lat_lng
    [self.lat, self.lng]
  end
  
  ## Join all the address parts
  # @param joiner [String] Delimiter to put between the parts
  # @return [String] Addresses joined together
  def to_s(joiner = ", ")
    address_parts.join(joiner)
  end
  
  def country_name
    return if country.blank?
    Carmen.country_name(country)
  end
  
  module Addressable
    
    def has_address(name = :address, options = {})
      name = name.to_sym
      options = {:as => :addressable, :class_name => "Address"}
      options[:dependent] = options.fetch(:dependent, :destroy)
      has_one name, options
      accepts_nested_attributes_for name
      attr_accessible :"#{name}_attributes"
    end
    
    def has_many_addresses(name = :addresses, options = {})
      name = name.to_s.pluralize.to_sym
      options = {:as => :addressable, :class_name => "Address"}
      options[:dependent] = options.fetch(:dependent, :destroy)
      has_many name, options
      accepts_nested_attributes_for name
      attr_accessible :"#{name}_attributes"
    end
    
  end
  
  def for_user?
    addressable.present? && addressable.is_a?(User)
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
