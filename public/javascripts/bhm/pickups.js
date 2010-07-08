BHM.withNS('Pickups', function(ns) {
  var bounds, lastMarker, lastWindow, map, markerURL, markers, pickups, selected;
  ns.mixin('Callbacks');
  ns.defineCallback('PickupSelect');
  map = null;
  bounds = null;
  lastMarker = null;
  lastWindow = null;
  selected = null;
  pickups = {};
  markers = {};
  ns.containerSelector = "#pickups-map";
  ns.listingSelector = "#pickups-listing";
  ns.entrySelector = ".pickup-entry";
  ns.defaultMapOptions = {
    zoom: 10,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: false
  };
  ns.Pickup = function(id, name, address, lat, lng, at, comment) {
    this.id = id;
    this.name = name;
    this.address = address;
    this.lat = lat;
    this.lng = lng;
    this.pickupAt = at;
    this.comment = comment;
    return this;
  };
  ns.Pickup.prototype.toString = function() {
    var _a, string;
    string = ("" + this.name + " (" + this.address + ")");
    if ((typeof (_a = this.pickupAt) !== "undefined" && _a !== null)) {
      string += (", pickup at " + this.pickupAt);
    }
    return string;
  };
  ns.Pickup.prototype.toLatLng = function() {
    var _a;
    return this._ll = (typeof (_a = this._ll) !== "undefined" && _a !== null) ? this._ll : new google.maps.LatLng(this.lat, this.lng);
  };
  ns.Pickup.prototype.toMarker = function(map) {
    var options;
    options = {
      title: this.toString(),
      position: this.toLatLng(),
      map: map
    };
    return new google.maps.Marker(options);
  };
  ns.Pickup.prototype.toInfoWindow = function(map, marker) {
    var _a, _b, info, inner;
    info = new google.maps.InfoWindow();
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
      }).text("Pickup at " + this.pickupAt));
    }
    if ((typeof (_b = this.comment) !== "undefined" && _b !== null)) {
      inner.append($("<br />"));
      inner.append($("<span />", {
        'class': 'pickup-comment'
      }).text(this.comment));
    }
    info.setContent(inner.get(0));
    info.open(map, marker);
    return info;
  };

  markerURL = function(selected) {
    var suffix;
    suffix = selected ? "_green" : "";
    return "http://www.google.com/intl/en_ALL/mapfiles/marker" + (suffix) + ".png";
  };
  ns.selectPickup = function(pickup, clearWindow) {
    var marker;
    if (clearWindow && (typeof lastWindow !== "undefined" && lastWindow !== null)) {
      lastWindow.close();
    }
    if (typeof pickup === "number") {
      pickup = ns.getPickup(pickup);
    }
    if (!(typeof pickup !== "undefined" && pickup !== null)) {
      return null;
    }
    marker = ns.getMarker(pickup.id);
    if (!(typeof marker !== "undefined" && marker !== null)) {
      return null;
    }
    if (typeof lastMarker !== "undefined" && lastMarker !== null) {
      lastMarker.setIcon(markerURL(false));
    }
    marker.setIcon(markerURL(true));
    lastMarker = marker;
    ns.invokePickupSelect(pickup);
    return true;
  };
  ns.eachPickup = function(callback) {
    return $.each(pickups, function() {
      return callback(this);
    });
  };
  ns.getPickup = function(id) {
    return pickups[id];
  };
  ns.getMarker = function(pickup) {
    var _a;
    if ((typeof (_a = pickup.id) !== "undefined" && _a !== null)) {
      pickup = pickup.id;
    }
    return markers[pickup];
  };
  ns.getMap = function() {
    var container, options;
    if (!(typeof map !== "undefined" && map !== null)) {
      options = $.extend({}, ns.defaultMapOptions);
      container = $(ns.containerSelector);
      BHM.Maps.makeDynamic(container);
      map = new google.maps.Map(container.get(0), options);
    }
    return map;
  };
  ns.getBounds = function() {
    return bounds = (typeof bounds !== "undefined" && bounds !== null) ? bounds : new google.maps.LatLngBounds();
  };
  ns.addAllPickups = function() {
    var container;
    container = $("" + ns.listingSelector + " " + ns.entrySelector);
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
    selected = container.filter("[data-" + ns.dataPrefix + "-selected]");
    return selected;
  };
  ns.plotPickups = function() {
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
  ns.centreMap = function() {
    map = ns.getMap();
    bounds = ns.getBounds();
    map.setCenter(bounds.getCenter());
    map.panToBounds(bounds);
    return map.fitBounds(bounds);
  };
  ns.plot = function() {
    ns.getMap();
    return ns.plotPickups();
  };
  ns.autoplot = function() {
    ns.addAllPickups();
    return ns.plot();
  };
  ns.setup = function() {
    return ns.autoplot();
  };
  return ns.setup;
});