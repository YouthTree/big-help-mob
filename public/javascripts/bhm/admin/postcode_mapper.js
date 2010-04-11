BHM.withNS('Admin.PostcodeMapper', function(ns) {
  
  ns.listSelector = '#user-location-list';
  ns.itemSelector = 'li';
  ns.mapSelector  = '#user-locations-map';
  ns.mapOptions   = {
    zoom:        10,
    mapTypeId:   google.maps.MapTypeId.ROADMAP,
    scrollwheel: false
  };
  
  var postcodes = [];
  var map;
  
  ns.defineClass('Postcode', function() {
    
    this.initialize = function(postcode, lat, lng, count) {
      this.postcode = postcode;
      this.lat      = lat;
      this.lng      = lng;
      this.count    = count;
      this.title    = "Postcodes: " + postcode;
    };
    
    this.toLatLng = function() {
      if(!this.__latlng)
        this.__latlng = new google.maps.LatLng(this.lat, this.lng);
      return this.__latlng;
    };
    
    this.toMarker = function(map, options) {
      if(!options) options = {};
      var o      = $.extend({}, options);
      o.title    = this.title;
      o.position = this.toLatLng();
      o.map      = map;
      console.log(o);
      return new google.maps.Marker(o);
    };
    
  });
  
  ns.addPostcode = function(postcode, lat, lng, count) {
    postcodes.push(new ns.Postcode(postcode, lat, lng, count));
  };
  
  ns.autoAddPostcodes = function() {
    $(ns.listSelector + ' ' + ns.itemSelector).each(function() {
      var e = $(this);
      ns.addPostcode(e.attr("data-postcode"), Number(e.attr("data-postcode-lat")), Number(e.attr("data-postcode-lng")), Number(e.attr("data-postcode-count")));
    });
  };
  
  ns.getMap = function() {
    if(map) return map;
    var container = $(ns.mapSelector);
    container.addClass('dynamic-google-map').removeClass('static-google-map').empty();
    map = new google.maps.Map(container.get(0), ns.mapOptions);
    return map;
  };
  
  ns.addMarkers = function() {
    var currentMap = this.getMap();
    if(!this.bounds) this.bounds = new google.maps.LatLngBounds();
    var b = this.bounds;
    var markers = [];
    $.each(postcodes, function() {
      for(var i = 0; i < this.count; i++)
        markers.push(this.toMarker(currentMap));
      b.extend(this.toLatLng());
    });
    var cluster = new MarkerClusterer(currentMap, markers);
    currentMap.setCenter(b.getCenter());
    currentMap.panToBounds(b);
    currentMap.fitBounds(b);
  };
  
  ns.setup = function() {
    ns.autoAddPostcodes();
    ns.addMarkers();
  };
  
});