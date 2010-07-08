BHM.withNS('Pickups', function(ns) {
  var bounds, lastMarker, lastWindow, map, markerURL, markers, pickups, selected;
  ns.mixin('Callbacks');
  ns.defineCallback('PickupSelect');
  // State
  map = null;
  bounds = null;
  lastMarker = null;
  lastWindow = null;
  selected = null;
  // Datastructures.
  pickups = {};
  // Each pickup point.
  markers = {};
  // Each marker point.
  // Configuration
  ns.containerSelector = "#pickups-map";
  ns.listingSelector = "#pickups-listing";
  ns.entrySelector = ".pickup-entry";
  ns.defaultMapOptions = {
    zoom: 10,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: false
  };
  // Pickup Datastructure.
  ns.Pickup = function Pickup(id, name, address, lat, lng, at, comment) {
    this.id = id;
    this.name = name;
    this.address = address;
    this.lat = lat;
    this.lng = lng;
    this.pickupAt = at;
    this.comment = comment;
    return this;
  };
  ns.Pickup.prototype.toString = function toString() {
    var _a, string;
    string = ("" + this.name + " (" + this.address + ")");
    if ((typeof (_a = this.pickupAt) !== "undefined" && _a !== null)) {
      string += (", pickup at " + this.pickupAt);
    }
    return string;
  };
  ns.Pickup.prototype.toLatLng = function toLatLng() {
    var _a;
    return this._ll = (typeof (_a = this._ll) !== "undefined" && _a !== null) ? this._ll : new google.maps.LatLng(this.lat, this.lng);
  };
  ns.Pickup.prototype.toMarker = function toMarker(map) {
    var options;
    options = {
      title: this.toString(),
      position: this.toLatLng(),
      map: map
    };
    return new google.maps.Marker(options);
  };
  ns.Pickup.prototype.toInfoWindow = function toInfoWindow(map, marker) {
    var _a, _b, info, inner;
    info = new google.maps.InfoWindow();
    // Create inner.
    inner = $("<div />");
    inner.append($("<strong />").text(this.name));
    inner.append($("<br />"));
    inner.append($("<span />", {
      'class': 'address'
    }).text(this.address));
    if ((typeof (_a = this.pickupAt) !== "undefined" && _a !== null)) {
      inner.append($("<br />"));
      inner.append($("<span />", {
        'class': 'pickup-at'
      }).text(("Pickup at " + this.pickupAt)));
    }
    if ((typeof (_b = this.comment) !== "undefined" && _b !== null)) {
      inner.append($("<br />"));
      inner.append($("<span />", {
        'class': 'pickup-comment'
      }).text(this.comment));
      // Actually show it.
    }
    info.setContent(inner.get(0));
    info.open(map, marker);
    return info;
  };
  markerURL = function markerURL(selected) {
    var suffix;
    suffix = selected ? "_green" : "";
    return "http://www.google.com/intl/en_ALL/mapfiles/marker" + (suffix) + ".png";
  };
  // Public API.
  ns.selectPickup = function selectPickup(pickup, clearWindow) {
    var marker;
    if (clearWindow && (typeof lastWindow !== "undefined" && lastWindow !== null)) {
      lastWindow.close();
    }
    if (typeof pickup === "number") {
      pickup = ns.getPickup(pickup);
    }
    if (!((typeof pickup !== "undefined" && pickup !== null))) {
      return null;
    }
    marker = ns.getMarker(pickup.id);
    if (!((typeof marker !== "undefined" && marker !== null))) {
      return null;
    }
    if ((typeof lastMarker !== "undefined" && lastMarker !== null)) {
      lastMarker.setIcon(markerURL(false));
    }
    marker.setIcon(markerURL(true));
    lastMarker = marker;
    ns.invokePickupSelect(pickup);
    return true;
  };
  ns.eachPickup = function eachPickup(callback) {
    return $.each(pickups, function() {
      return callback(this);
    });
  };
  ns.getPickup = function getPickup(id) {
    return pickups[id];
  };
  ns.getMarker = function getMarker(pickup) {
    var _a;
    if ((typeof (_a = pickup.id) !== "undefined" && _a !== null)) {
      pickup = pickup.id;
    }
    return markers[pickup];
  };
  ns.getMap = function getMap() {
    var container, options;
    if (!(typeof map !== "undefined" && map !== null)) {
      options = $.extend({}, ns.defaultMapOptions);
      container = $(ns.containerSelector);
      BHM.Maps.makeDynamic(container);
      map = new google.maps.Map(container.get(0), options);
    }
    return map;
  };
  ns.getBounds = function getBounds() {
    return bounds = (typeof bounds !== "undefined" && bounds !== null) ? bounds : new google.maps.LatLngBounds();
  };
  ns.addAllPickups = function addAllPickups() {
    var container;
    container = $(("" + ns.listingSelector + " " + ns.entrySelector));
    container.each(function() {
      var address, at, comment, element, id, lat, lng, name;
      element = $(this);
      if (ns.hasData(element, "pickup-id")) {
        id = Number(ns.data(element, "pickup-id"));
        lat = Number(ns.data(element, "pickup-latitude"));
        lng = Number(ns.data(element, "pickup-longitude"));
        name = ns.data(element, "pickup-name");
        address = ns.data(element, "pickup-address");
        at = ns.data(element, "pickup-at");
        comment = ns.data(element, "pickup-comment");
        pickups[id] = new ns.Pickup(id, name, address, lat, lng, at, comment);
        return pickups[id];
      }
    });
    selected = container.filter(("[data-" + ns.dataPrefix + "-selected]"));
    return selected;
  };
  ns.plotPickups = function plotPickups() {
    map = ns.getMap();
    bounds = ns.getBounds();
    ns.eachPickup(function(pickup) {
      var marker;
      marker = pickup.toMarker(map);
      markers[pickup.id] = marker;
      bounds.extend(pickup.toLatLng());
      return BHM.Maps.on('click', marker, function() {
        ns.selectPickup(pickup, true);
        lastWindow = pickup.toInfoWindow(map, marker);
        return lastWindow;
      });
    });
    return ns.centreMap();
  };
  ns.centreMap = function centreMap() {
    map = ns.getMap();
    bounds = ns.getBounds();
    map.setCenter(bounds.getCenter());
    map.panToBounds(bounds);
    return map.fitBounds(bounds);
  };
  ns.plot = function plot() {
    ns.getMap();
    return ns.plotPickups();
  };
  ns.autoplot = function autoplot() {
    ns.addAllPickups();
    return ns.plot();
  };
  // Setup tools.
  ns.setup = function setup() {
    return ns.autoplot();
  };
  return ns.setup;
});