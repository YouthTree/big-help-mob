require 'spec_helper'

describe Address do

  before :each do
    @address = Address.new
  end

  context '.geocode' do
    it 'should cache the setting' do
      mock(Geokit::Geocoders::MultiGeocoder).geocode('1 Flatley Street').returns(
        OpenStruct.new(:lat => 12.0, :lng => 31.2, :success => true))

      @address.street1 = '1 Flatley Street'
      @address.geocode.should == [12.0, 31.2]
    end
  end

  context '.to_lat_lng' do
    it 'should return a latitude and longitude' do
      @address.lat = 12.0
      @address.lng = 31.2
      @address.to_lat_lng.should == [12.0, 31.2]
    end

    it 'should return nil,nil' do
      @address.to_lat_lng.should == [nil, nil]
    end
  end

  context '.to_s' do
    it 'should stringify the address' do
      @address.to_s.should == ''
      @address.to_s(', ').should == ''

      @address.street1 = '22 Portobello Road'
      @address.city = 'London'
      @address.country = 'United Kingdom'
      @address.to_s(', ').should == '22 Portobello Road, London'
    end
  end

  context '.country_name' do
    it 'should return nil for an unassigned country name' do
      @address.country_name.should be_nil
    end

    it 'should return the country name' do
      @address.country = 'US'
      @address.country_name.should == 'United States'
    end
  end

  context '.for_user?' do
    it 'should return false if it has no addressable' do
      @address.for_user?.should be_false
    end

    it 'should return true if it is owned by a User' do
      @address.addressable = User.new
      @address.for_user?.should be_true
    end
  end

end
