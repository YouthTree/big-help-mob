require 'test_helper'


Geokit::Geocoders::provider_order = [:google, :us]

class ActsAsMappableTest < GeokitTestCase
  
  LOCATION_A_IP = "217.10.83.5"
  
  def setup
    @location_a = GeoKit::GeoLoc.new
    @location_a.lat = 32.918593
    @location_a.lng = -96.958444
    @location_a.city = "Irving"
    @location_a.state = "TX"
    @location_a.country_code = "US"
    @location_a.success = true
    
    @sw = GeoKit::LatLng.new(32.91663,-96.982841)
    @ne = GeoKit::LatLng.new(32.96302,-96.919495)
    @bounds_center=GeoKit::LatLng.new((@sw.lat+@ne.lat)/2,(@sw.lng+@ne.lng)/2)
    
    @starbucks = companies(:starbucks)
    @loc_a = locations(:a)
    @custom_loc_a = custom_locations(:a)
    @loc_e = locations(:e)
    @custom_loc_e = custom_locations(:e)
  
    @barnes_and_noble = mock_organizations(:barnes_and_noble)
    @address = mock_addresses(:address_barnes_and_noble)
  end
  
  def test_override_default_units_the_hard_way
    Location.default_units = :kms
    locations = Location.find(:all, :origin => @loc_a, :conditions => "distance < 3.97")
    assert_equal 5, locations.size   
    locations = Location.count(:origin => @loc_a, :conditions => "distance < 3.97")
    assert_equal 5, locations
    Location.default_units = :miles
  end
  
  def test_include
    locations = Location.find(:all, :origin => @loc_a, :include => :company, :conditions => "company_id = 1")
    assert !locations.empty?
    assert_equal 1, locations[0].company.id
    assert_equal 'Starbucks', locations[0].company.name
  end
  
  def test_distance_between_geocoded
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with("Irving, TX").returns(@location_a)
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with("San Francisco, CA").returns(@location_a)
    assert_equal 0, Location.distance_between("Irving, TX", "San Francisco, CA") 
  end
  
  def test_distance_to_geocoded
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with("Irving, TX").returns(@location_a)
    assert_equal 0, @custom_loc_a.distance_to("Irving, TX") 
  end
  
  def test_distance_to_geocoded_error
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with("Irving, TX").returns(GeoKit::GeoLoc.new)
    assert_raise(GeoKit::Geocoders::GeocodeError) { @custom_loc_a.distance_to("Irving, TX")  }
  end
  
  def test_custom_attributes_distance_calculations
    assert_equal 0, @custom_loc_a.distance_to(@loc_a)
    assert_equal 0, CustomLocation.distance_between(@custom_loc_a, @loc_a)
  end
  
  def test_distance_column_in_select
    locations = Location.find(:all, :origin => @loc_a, :order => "distance ASC")
    assert_equal 6, locations.size
    assert_equal 0, @loc_a.distance_to(locations.first)
    assert_in_delta 3.97, @loc_a.distance_to(locations.last, :units => :miles, :formula => :sphere), 0.01
  end
  
  def test_find_with_distance_condition
    locations = Location.find(:all, :origin => @loc_a, :conditions => "distance < 3.97")
    assert_equal 5, locations.size
    locations = Location.count(:origin => @loc_a, :conditions => "distance < 3.97")
    assert_equal 5, locations
  end 
  
  def test_find_with_distance_condition_with_units_override
    locations = Location.find(:all, :origin => @loc_a, :units => :kms, :conditions => "distance < 6.387")
    assert_equal 5, locations.size
    locations = Location.count(:origin => @loc_a, :units => :kms, :conditions => "distance < 6.387")
    assert_equal 5, locations
  end
  
  def test_find_with_distance_condition_with_formula_override
    locations = Location.find(:all, :origin => @loc_a, :formula => :flat, :conditions => "distance < 6.387")
    assert_equal 6, locations.size
    locations = Location.count(:origin => @loc_a, :formula => :flat, :conditions => "distance < 6.387")
    assert_equal 6, locations
  end
  
  def test_find_within
    locations = Location.find_within(3.97, :origin => @loc_a)
    assert_equal 5, locations.size 
    locations = Location.count_within(3.97, :origin => @loc_a)
    assert_equal 5, locations   
  end
  
  def test_find_within_with_token
    locations = Location.find(:all, :within => 3.97, :origin => @loc_a)
    assert_equal 5, locations.size    
    locations = Location.count(:within => 3.97, :origin => @loc_a)
    assert_equal 5, locations
  end
  
  def test_find_within_with_coordinates
    locations = Location.find_within(3.97, :origin =>[@loc_a.lat,@loc_a.lng])
    assert_equal 5, locations.size    
    locations = Location.count_within(3.97, :origin =>[@loc_a.lat,@loc_a.lng])
    assert_equal 5, locations
  end
  
  def test_find_with_compound_condition
    locations = Location.find(:all, :origin => @loc_a, :conditions => "distance < 5 and city = 'Coppell'")
    assert_equal 2, locations.size
    locations = Location.count(:origin => @loc_a, :conditions => "distance < 5 and city = 'Coppell'")
    assert_equal 2, locations
  end
  
  def test_find_with_secure_compound_condition
    locations = Location.find(:all, :origin => @loc_a, :conditions => ["distance < ? and city = ?", 5, 'Coppell'])
    assert_equal 2, locations.size
    locations = Location.count(:origin => @loc_a, :conditions => ["distance < ? and city = ?", 5, 'Coppell'])
    assert_equal 2, locations
  end
  
  def test_find_beyond
    locations = Location.find_beyond(3.95, :origin => @loc_a)
    assert_equal 1, locations.size    
    locations = Location.count_beyond(3.95, :origin => @loc_a)
    assert_equal 1, locations
  end
  
  def test_find_beyond_with_token
    locations = Location.find(:all, :beyond => 3.95, :origin => @loc_a)
    assert_equal 1, locations.size    
    locations = Location.count(:beyond => 3.95, :origin => @loc_a)
    assert_equal 1, locations
  end
  
  def test_find_beyond_with_coordinates
    locations = Location.find_beyond(3.95, :origin =>[@loc_a.lat, @loc_a.lng])
    assert_equal 1, locations.size    
    locations = Location.count_beyond(3.95, :origin =>[@loc_a.lat, @loc_a.lng])
    assert_equal 1, locations
  end
  
  def test_find_range_with_token
    locations = Location.find(:all, :range => 0..10, :origin => @loc_a)
    assert_equal 6, locations.size
    locations = Location.count(:range => 0..10, :origin => @loc_a)
    assert_equal 6, locations
  end
  
  def test_find_range_with_token_with_conditions
    locations = Location.find(:all, :origin => @loc_a, :range => 0..10, :conditions => ["city = ?", 'Coppell'])
    assert_equal 2, locations.size
    locations = Location.count(:origin => @loc_a, :range => 0..10, :conditions => ["city = ?", 'Coppell'])
    assert_equal 2, locations
  end
  
  def test_find_range_with_token_with_hash_conditions
    locations = Location.find(:all, :origin => @loc_a, :range => 0..10, :conditions => {:city => 'Coppell'})
    assert_equal 2, locations.size
    locations = Location.count(:origin => @loc_a, :range => 0..10, :conditions => {:city => 'Coppell'})
    assert_equal 2, locations
  end
  
  def test_find_range_with_token_excluding_end
    locations = Location.find(:all, :range => 0...10, :origin => @loc_a)
    assert_equal 6, locations.size
    locations = Location.count(:range => 0...10, :origin => @loc_a)
    assert_equal 6, locations
  end
  
  def test_find_nearest
    assert_equal @loc_a, Location.find_nearest(:origin => @loc_a)
  end
  
  def test_find_nearest_through_find
     assert_equal @loc_a, Location.find(:nearest, :origin => @loc_a)
  end
  
  def test_find_nearest_with_coordinates
    assert_equal @loc_a, Location.find_nearest(:origin =>[@loc_a.lat, @loc_a.lng])
  end
  
  def test_find_farthest
    assert_equal @loc_e, Location.find_farthest(:origin => @loc_a)
  end
  
  def test_find_farthest_through_find
    assert_equal @loc_e, Location.find(:farthest, :origin => @loc_a)
  end
  
  def test_find_farthest_with_coordinates
    assert_equal @loc_e, Location.find_farthest(:origin =>[@loc_a.lat, @loc_a.lng])
  end
  
  def test_scoped_distance_column_in_select
    locations = @starbucks.locations.find(:all, :origin => @loc_a, :order => "distance ASC")
    assert_equal 5, locations.size
    assert_equal 0, @loc_a.distance_to(locations.first)
    assert_in_delta 3.97, @loc_a.distance_to(locations.last, :units => :miles, :formula => :sphere), 0.01
  end
  
  def test_scoped_find_with_distance_condition
    locations = @starbucks.locations.find(:all, :origin => @loc_a, :conditions => "distance < 3.97")
    assert_equal 4, locations.size
    locations = @starbucks.locations.count(:origin => @loc_a, :conditions => "distance < 3.97")
    assert_equal 4, locations
  end 
  
  def test_scoped_find_within
    locations = @starbucks.locations.find_within(3.97, :origin => @loc_a)
    assert_equal 4, locations.size    
    locations = @starbucks.locations.count_within(3.97, :origin => @loc_a)
    assert_equal 4, locations
  end
  
  def test_scoped_find_with_compound_condition
    locations = @starbucks.locations.find(:all, :origin => @loc_a, :conditions => "distance < 5 and city = 'Coppell'")
    assert_equal 2, locations.size
    locations = @starbucks.locations.count( :origin => @loc_a, :conditions => "distance < 5 and city = 'Coppell'")
    assert_equal 2, locations
  end
  
  def test_scoped_find_beyond
    locations = @starbucks.locations.find_beyond(3.95, :origin => @loc_a)
    assert_equal 1, locations.size 
    locations = @starbucks.locations.count_beyond(3.95, :origin => @loc_a)
    assert_equal 1, locations   
  end
  
  def test_scoped_find_nearest
    assert_equal @loc_a, @starbucks.locations.find_nearest(:origin => @loc_a)
  end
  
  def test_scoped_find_farthest
    assert_equal @loc_e, @starbucks.locations.find_farthest(:origin => @loc_a)
  end  
  
  def test_ip_geocoded_distance_column_in_select
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    locations = Location.find(:all, :origin => LOCATION_A_IP, :order => "distance ASC")
    assert_equal 6, locations.size
    assert_equal 0, @loc_a.distance_to(locations.first)
    assert_in_delta 3.97, @loc_a.distance_to(locations.last, :units => :miles, :formula => :sphere), 0.01
  end
  
  def test_ip_geocoded_find_with_distance_condition
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    locations = Location.find(:all, :origin => LOCATION_A_IP, :conditions => "distance < 3.97")
    assert_equal 5, locations.size
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    locations = Location.count(:origin => LOCATION_A_IP, :conditions => "distance < 3.97")
    assert_equal 5, locations
  end 
  
  def test_ip_geocoded_find_within
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    locations = Location.find_within(3.97, :origin => LOCATION_A_IP)
    assert_equal 5, locations.size    
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    locations = Location.count_within(3.97, :origin => LOCATION_A_IP)
    assert_equal 5, locations
  end
  
  def test_ip_geocoded_find_with_compound_condition
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    locations = Location.find(:all, :origin => LOCATION_A_IP, :conditions => "distance < 5 and city = 'Coppell'")
    assert_equal 2, locations.size
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    locations = Location.count(:origin => LOCATION_A_IP, :conditions => "distance < 5 and city = 'Coppell'")
    assert_equal 2, locations
  end
  
  def test_ip_geocoded_find_with_secure_compound_condition
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    locations = Location.find(:all, :origin => LOCATION_A_IP, :conditions => ["distance < ? and city = ?", 5, 'Coppell'])
    assert_equal 2, locations.size
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    locations = Location.count(:origin => LOCATION_A_IP, :conditions => ["distance < ? and city = ?", 5, 'Coppell'])
    assert_equal 2, locations
  end
  
  def test_ip_geocoded_find_beyond
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    locations = Location.find_beyond(3.95, :origin => LOCATION_A_IP)
    assert_equal 1, locations.size    
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    locations = Location.count_beyond(3.95, :origin => LOCATION_A_IP)
    assert_equal 1, locations
  end
  
  def test_ip_geocoded_find_nearest
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    assert_equal @loc_a, Location.find_nearest(:origin => LOCATION_A_IP)
  end
  
  def test_ip_geocoded_find_farthest
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with(LOCATION_A_IP).returns(@location_a)
    assert_equal @loc_e, Location.find_farthest(:origin => LOCATION_A_IP)
  end
  
  def test_ip_geocoder_exception
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with('127.0.0.1').returns(GeoKit::GeoLoc.new)
    assert_raises GeoKit::Geocoders::GeocodeError do
      Location.find_farthest(:origin => '127.0.0.1')
    end
  end
  
  def test_address_geocode
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with('Irving, TX').returns(@location_a)  
    locations = Location.find(:all, :origin => 'Irving, TX', :conditions => ["distance < ? and city = ?", 5, 'Coppell'])
    assert_equal 2, locations.size
  end
  
  def test_find_with_custom_distance_condition
    locations = CustomLocation.find(:all, :origin => @loc_a, :conditions => "dist < 3.97")
    assert_equal 5, locations.size 
    locations = CustomLocation.count(:origin => @loc_a, :conditions => "dist < 3.97")
    assert_equal 5, locations
  end  
  
  def test_find_with_custom_distance_condition_using_custom_origin
    locations = CustomLocation.find(:all, :origin => @custom_loc_a, :conditions => "dist < 3.97")
    assert_equal 5, locations.size 
    locations = CustomLocation.count(:origin => @custom_loc_a, :conditions => "dist < 3.97")
    assert_equal 5, locations
  end
  
  def test_find_within_with_custom
    locations = CustomLocation.find_within(3.97, :origin => @loc_a)
    assert_equal 5, locations.size    
    locations = CustomLocation.count_within(3.97, :origin => @loc_a)
    assert_equal 5, locations
  end
  
  def test_find_within_with_coordinates_with_custom
    locations = CustomLocation.find_within(3.97, :origin =>[@loc_a.lat, @loc_a.lng])
    assert_equal 5, locations.size    
    locations = CustomLocation.count_within(3.97, :origin =>[@loc_a.lat, @loc_a.lng])
    assert_equal 5, locations
  end
  
  def test_find_with_compound_condition_with_custom
    locations = CustomLocation.find(:all, :origin => @loc_a, :conditions => "dist < 5 and city = 'Coppell'")
    assert_equal 1, locations.size
    locations = CustomLocation.count(:origin => @loc_a, :conditions => "dist < 5 and city = 'Coppell'")
    assert_equal 1, locations
  end
  
  def test_find_with_secure_compound_condition_with_custom
    locations = CustomLocation.find(:all, :origin => @loc_a, :conditions => ["dist < ? and city = ?", 5, 'Coppell'])
    assert_equal 1, locations.size
    locations = CustomLocation.count(:origin => @loc_a, :conditions => ["dist < ? and city = ?", 5, 'Coppell'])
    assert_equal 1, locations
  end
  
  def test_find_beyond_with_custom
    locations = CustomLocation.find_beyond(3.95, :origin => @loc_a)
    assert_equal 1, locations.size  
    locations = CustomLocation.count_beyond(3.95, :origin => @loc_a)
    assert_equal 1, locations  
  end
  
  def test_find_beyond_with_coordinates_with_custom
    locations = CustomLocation.find_beyond(3.95, :origin =>[@loc_a.lat, @loc_a.lng])
    assert_equal 1, locations.size    
    locations = CustomLocation.count_beyond(3.95, :origin =>[@loc_a.lat, @loc_a.lng])
    assert_equal 1, locations
  end
  
  def test_find_nearest_with_custom
    assert_equal @custom_loc_a, CustomLocation.find_nearest(:origin => @loc_a)
  end
  
  def test_find_nearest_with_coordinates_with_custom
    assert_equal @custom_loc_a, CustomLocation.find_nearest(:origin =>[@loc_a.lat, @loc_a.lng])
  end
  
  def test_find_farthest_with_custom
    assert_equal @custom_loc_e, CustomLocation.find_farthest(:origin => @loc_a)
  end
  
  def test_find_farthest_with_coordinates_with_custom
    assert_equal @custom_loc_e, CustomLocation.find_farthest(:origin =>[@loc_a.lat, @loc_a.lng])
  end
  
  def test_find_with_array_origin
    locations = Location.find(:all, :origin =>[@loc_a.lat,@loc_a.lng], :conditions => "distance < 3.97")
    assert_equal 5, locations.size
    locations = Location.count(:origin =>[@loc_a.lat,@loc_a.lng], :conditions => "distance < 3.97")
    assert_equal 5, locations
  end
  
  
  # Bounding box tests
  
  def test_find_within_bounds
    locations = Location.find_within_bounds([@sw,@ne])
    assert_equal 2, locations.size
    locations = Location.count_within_bounds([@sw,@ne])
    assert_equal 2, locations
  end
  
  def test_find_within_bounds_ordered_by_distance
    locations = Location.find_within_bounds([@sw,@ne], :origin=>@bounds_center, :order=>'distance asc')
    assert_equal locations[0], locations(:d)
    assert_equal locations[1], locations(:a)
  end
  
  def test_find_within_bounds_with_token
    locations = Location.find(:all, :bounds=>[@sw,@ne])
    assert_equal 2, locations.size
    locations = Location.count(:bounds=>[@sw,@ne])
    assert_equal 2, locations  
  end
  
  def test_find_within_bounds_with_string_conditions
    locations = Location.find(:all, :bounds=>[@sw,@ne], :conditions=>"id !=#{locations(:a).id}")
    assert_equal 1, locations.size
  end
  
  def test_find_within_bounds_with_array_conditions
    locations = Location.find(:all, :bounds=>[@sw,@ne], :conditions=>["id != ?", locations(:a).id])
    assert_equal 1, locations.size
  end
  
  def test_find_within_bounds_with_hash_conditions
    locations = Location.find(:all, :bounds=>[@sw,@ne], :conditions=>{:id => locations(:a).id})
    assert_equal 1, locations.size
  end
  
  def test_auto_geocode
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with("Irving, TX").returns(@location_a)
    store=Store.new(:address=>'Irving, TX')
    store.save
    assert_equal store.lat,@location_a.lat  
    assert_equal store.lng,@location_a.lng
    assert_equal 0, store.errors.size
  end
  
  def test_auto_geocode_failure
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).with("BOGUS").returns(GeoKit::GeoLoc.new)
    store=Store.new(:address=>'BOGUS')
    store.save
    assert store.new_record?
    assert_equal 1, store.errors.size
  end
  
  # Test :through
    
  def test_find_with_through
    organizations = MockOrganization.find(:all, :origin => @location_a, :order => 'distance ASC')
    assert_equal 2, organizations.size
    organizations = MockOrganization.count(:origin => @location_a, :conditions => "distance < 3.97")
    assert_equal 1, organizations
  end
  
  def test_find_with_through_with_hash
    people = MockPerson.find(:all, :origin => @location_a, :order => 'distance ASC')
    assert_equal 2, people.size
    people = MockPerson.count(:origin => @location_a, :conditions => "distance < 3.97")
    assert_equal 2, people
  end 
end
