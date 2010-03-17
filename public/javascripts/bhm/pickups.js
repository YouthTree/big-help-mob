BHM.withNS('Pickups', function(ns) {
  
  var pickups = {};
  var plotted = false;
  var map;
  var mapBounds;
  
  ns.containerID  = "pickups-map";
  ns.listingID    = "pickups-listing";
  ns.listingClass = "pickup-entry";
  ns.dataPrefix   = "pickup-";
  ns.defaultMapOptions = {
    zoom: 10,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  
  ns.defineClass('Pickup', function() {
    
    this.initialize = function(id, title, lat, lng) {
      this.title = title;
      this.id    = id;
      this.lat   = lat;
      this.lng   = lng;
    };
    
    this.toString = function() {
      var s = "" + this.title;
      s += " (Pickup ID #" + this.id + ")";
      s += " at (" + this.lat + ", " + this.lng + ")";
      return s;
    }
    
    this.toMarker = function(map, options) {
      if(!options) options = {};
      var o      = $.extend({}, options);
      o.position = this.toLatLng();
      o.map      = map;
      return new google.maps.Marker(o);
    }
    
    this.toLatLng = function() {
      if(!this.__latlng)
        this.__latlng = new google.maps.LatLng(this.lat, this.lng);
      return this.__latlng;
    }
    
  });
  
  function addPickupToPlot(pickup) {
    var m = pickup.toMarker(ns.getMap());
    var b = ns.getBounds();
    b.extend(pickup.toLatLng());
    return m;
  }
  
  ns.getBounds = function() {
    if(!mapBounds) mapBounds = new google.maps.LatLngBounds();
    return mapBounds;
  }
  
  function pickupAttr(e, key) {
    return e.attr("data-" + ns.dataPrefix + key);
  }
  
  ns.addPickup = function(id, title, lat, lng) {
    var p = new ns.Pickup(id, title, lat, lng);
    pickups[p.id] = p;
    if(plotted) addPickupToPlot(p);
    return p;
  };
  
  ns.autoAddPickups = function(c) {
    if(!c) c = $("#" + ns.listingID + " ." + ns.listingClass);
    c.each(function() {
      var e = $(this);
      var id = pickupAttr(e, "id");
      if(id) {
        var title = pickupAttr(e, "title"),
            lat   = Number(pickupAttr(e, "latitude")),
            lng   = Number(pickupAttr(e, "longitude"));
        ns.addPickup(Number(id), title, lat, lng);
      };
    });
  };
  
  ns.getPickup = function(id) {
    return pickups[id];
  };
  
  ns.getMap = function() {
    ns.plot();
    return map;
  }
  
  ns.getContainer = function() {
    return document.getElementById(ns.containerID);
  }
  
  ns.plot = function(options) {
    if(map) return map;
    if(!options) options = {};
    var c = ns.getContainer();
    if(!c) return;
    var mapOptions = $.extend({}, options, ns.defaultMapOptions);
    map = new google.maps.Map(c, mapOptions);
    // Adding pickups
    for(var idx in pickups) {
      if(pickups.hasOwnProperty(idx)) addPickupToPlot(pickups[idx]);
    }
    ns.centreMap();
    return map;
  }
  
  ns.centreMap = function() {
    var m = ns.getMap();
    var b = ns.getBounds();
    m.setCenter(b.getCenter());
    m.panToBounds(b);
    m.fitBounds(b);
  }
  
  ns.automap = function() {
    var collection = $("#" + ns.listingID + " ." + ns.listingClass);
    if(collection.size() > 0) {
      ns.autoAddPickups(collection);
      return ns.getMap();
    }
  };
  
  $(document).ready(function() {
    ns.automap();
  });
  
});