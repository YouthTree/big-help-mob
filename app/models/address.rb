class Address < ActiveRecord::Base
  attr_accessible :street1, :street2, :city, :state, :postcode, :country
  
  belongs_to :addressable, :polymorphic => true
  
  validates_presence_of :street1, :city, :state, :country
  validates_presence_of :postcode, :if => :for_user?
  
  apply_addresslogic :fields => [:street1, :street2, :city, [:state, :postcode], :country_name]
  
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
    [addressable_id, addressable_type].all?(&:present?) && addressable_type == "User"
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