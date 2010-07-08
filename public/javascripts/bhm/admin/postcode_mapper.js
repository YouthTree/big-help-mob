BHM.withNS('Admin.PostcodeMapper', function(ns) {
  var map, postcodes;
  ns.listSelector = '#user-location-list';
  ns.itemSelector = 'li';
  ns.mapSelector = '#user-locations-map';
  ns.mapOptions = {
    zoom: 10,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: false
  };
  postcodes = [];
  map = null;
  ns.Postcode = function(postcode, lat, lng, count) {
    this.postcode = postcode;
    this.lat = lat;
    this.lng = lng;
    this.count = count;
    this.title = ("" + count + " people from " + postcode);
    return this;
  };
  ns.Postcode.prototype.toLatLng = function() {
    var _a;
    return this.__latlng = (typeof (_a = this.__latlng) !== "undefined" && _a !== null) ? this.__latlng : new google.maps.LatLng(this.lat, this.lng);
  };
  ns.Postcode.prototype.toMarker = function(map, opts) {
    var options;
    opts = (typeof opts !== "undefined" && opts !== null) ? opts : {};
    options = $.extend({}, opts);
    options.title = this.title;
    options.position = this.toLatLng();
    options.map = map;
    return new google.maps.Marker(options);
  };

  ns.addPostcode = function(postcode, lat, lng, count) {
    return postcodes.push(new ns.Postcode(postcode, lat, lng, count));
  };
  ns.autoAddPostcodes = function() {
    return $("" + ns.listSelector + " " + ns.itemSelector).each(function() {
      var element;
      element = $(this);
      return ns.addPostcode(ns.data(element, "postcode"), Number(ns.data(element, "postcode-lat")), Number(ns.data(element, "postcode-lng")), Number(ns.data(element, "postcode-count")));
    });
  };
  ns.getMap = function() {
    var container;
    if (typeof map !== "undefined" && map !== null) {
      return map;
    }
    container = $(ns.mapSelector);
    BHM.Maps.makeDynamic(container);
    map = new google.maps.Map(container.get(0), ns.mapOptions);
    return map;
  };
  ns.addMarkers = function() {
    var _a, _b, _c, _d, _e, cluster, currentMap, i, markers, postcode;
    currentMap = this.getMap();
    this.bounds = (typeof (_a = this.bounds) !== "undefined" && _a !== null) ? this.bounds : new google.maps.LatLngBounds();
    markers = [];
    _c = postcodes;
    for (_b = 0, _d = _c.length; _b < _d; _b++) {
      postcode = _c[_b];
      (_e = postcode.count);

      for (i = 0; i <= _e; i += 1) {
        markers.push(postcode.toMarker(currentMap));
      }
      this.bounds.extend(postcode.toLatLng());
    }
    cluster = new MarkerClusterer(currentMap, markers);
    currentMap.setCenter(this.bounds.getCenter());
    return currentMap.fitBounds(this.bounds);
  };
  ns.setup = function() {
    ns.autoAddPostcodes();
    return ns.addMarkers();
  };
  return ns.setup;
});