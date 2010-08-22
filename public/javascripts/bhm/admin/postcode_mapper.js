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
  ns.Postcode = function(_a, _b, _c, _d) {
    this.count = _d;
    this.lng = _c;
    this.lat = _b;
    this.postcode = _a;
    this.title = ("" + (this.count) + " people from " + (this.postcode));
    return this;
  };
  ns.Postcode.prototype.toLatLng = function() {
    return this.__latlng = (typeof this.__latlng !== "undefined" && this.__latlng !== null) ? this.__latlng : new google.maps.LatLng(this.lat, this.lng);
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
    return $(("" + (ns.listSelector) + " " + (ns.itemSelector))).each(function() {
      var element;
      element = $(this);
      return ns.addPostcode(ns.data(element, "postcode"), Number(ns.data(element, "postcode-lat")), Number(ns.data(element, "postcode-lng")), Number(ns.data(element, "postcode-count")));
    });
  };
  ns.getMap = function() {
    var container;
    if ((typeof map !== "undefined" && map !== null)) {
      return map;
    }
    container = $(ns.mapSelector);
    BHM.Maps.makeDynamic(container);
    return (map = new google.maps.Map(container.get(0), ns.mapOptions));
  };
  ns.addMarkers = function() {
    var _a, _b, _c, _d, cluster, currentMap, i, markers, postcode;
    currentMap = this.getMap();
    this.bounds = (typeof this.bounds !== "undefined" && this.bounds !== null) ? this.bounds : new google.maps.LatLngBounds();
    markers = [];
    _b = postcodes;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      postcode = _b[_a];
      _d = postcode.count;
      for (i = 0; (0 <= _d ? i <= _d : i >= _d); (0 <= _d ? i += 1 : i -= 1)) {
        markers.push(postcode.toMarker(currentMap));
      }
      this.bounds.extend(postcode.toLatLng());
    }
    cluster = new MarkerClusterer(currentMap, markers);
    currentMap.setCenter(this.bounds.getCenter());
    return currentMap.fitBounds(this.bounds);
  };
  return (ns.setup = function() {
    ns.autoAddPostcodes();
    return ns.addMarkers();
  });
});