BHM.withNS('Pickups', function(ns) {
  
  var pickups = {};
  var markers = {};
  var map;
  var mapBounds;
  
  var lastSelected;
  var selectedCallback;
  
  var iconOffset = 0;
  
  var imagePathPrefix = "http://www.google.com/intl/en_ALL/mapfiles/";
  
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
    givePickupNumber(pickup);
    var m = pickup.toMarker(ns.getMap(), {icon: normalMarkerImage(pickup)});
    var b = ns.getBounds();
    b.extend(pickup.toLatLng());
    markers[pickup.id] = m;
    return m;
  }
  
  ns.getBounds = function() {
    if(!mapBounds) mapBounds = new google.maps.LatLngBounds();
    return mapBounds;
  }
  
  function pickupAttr(e, key) {
    return e.attr("data-" + ns.dataPrefix + key);
  }
  
  function givePickupNumber(pu) {
    if(!pu.iconOffset) pu.iconOffset = iconOffset++;
    return pu.iconOffset;
  }
  
  function markerImageWithPath(path) {
    return new google.maps.MarkerImage(path);
  }
  
  var startLetter = 65; // Initial letter offset
  
  function lookupCharForOffset(offset) {
    return String.fromCharCode(startLetter + (offset % 26));
  }
  
  function normalMarkerImage(pu) {
    var path = imagePathPrefix + "marker" + lookupCharForOffset(pu.iconOffset) + ".png";
    return markerImageWithPath(path);
  }
  
  function selectedMarkerImage(pu) {
    var path = imagePathPrefix + "marker_green" + lookupCharForOffset(pu.iconOffset) + ".png";
    return markerImageWithPath(path);
  }
  
  ns.addPickup = function(id, title, lat, lng) {
    var p = new ns.Pickup(id, title, lat, lng);
    pickups[p.id] = p;
    if(map) addPickupToPlot(p);
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
  
  ns.getPickupMarker = function(id) {
    var pu = ns.getPickup(id);
    if(pu) return markers[id];
  };
  
  ns.getMap = function() {
    ns.plot();
    return map;
  };
  
  ns.onEvent = function(obj, name, handler) {
    google.maps.event.addListener(obj, name, handler);
  };
  
  ns.onMapEvent = function(name, handler) {
    return ns.onEvent(ns.getMap(), name, handler);
  };
  
  ns.onPickupEvent = function(id, name, handler) {
    var m = ns.getPickupMarker(id);
    if(m) return ns.onEvent(m, name, handler);
  }
  
  ns.onEachPickupEvent = function(name, handler) {
    ns.eachPickup(function(pu) {
      ns.onPickupEvent(pu.id, name, function() {
        // Append the pickup to the arguments.
        var args = Array.prototype.slice.apply(arguments);
        args.unshift(pu);
        // Reapply in this scope w/ pickup as the first argument.
        handler.apply(this, args);
      });
    });
  }
  
  ns.getContainer = function() {
    return document.getElementById(ns.containerID);
  };
  
  ns.eachPickup = function(f) {
    for(var idx in pickups) {
      if(pickups.hasOwnProperty(idx)) f(pickups[idx]);
    }
  };
  
  ns.plot = function(options) {
    if(map) return map;
    if(!options) options = {};
    var c = ns.getContainer();
    if(!c) return;
    var mapOptions = $.extend({}, options, ns.defaultMapOptions);
    $(c).addClass('dynamic-google-map').removeClass('static-google-map').empty();
    map = new google.maps.Map(c, mapOptions);
    // Adding pickups
    ns.eachPickup(addPickupToPlot);
    ns.centreMap();
    return map;
  };
  
  ns.centreMap = function() {
    var m = ns.getMap();
    var b = ns.getBounds();
    m.setCenter(b.getCenter());
    m.panToBounds(b);
    m.fitBounds(b);
  };
  
  ns.onPickupSelect = function(cb) {
    selectedCallback = cb;
  }
  
  ns.selectPickup = function(pu) {
    if(typeof(pu) == "number") pu = ns.getPickup(pu);
    if(!pu) return;
    var marker = markers[pu.id];
    if(lastSelected) markers[lastSelected.id].setIcon(normalMarkerImage(lastSelected));
    lastSelected = pu;
    marker.setIcon(selectedMarkerImage(pu));
    if(typeof(selectedCallback) == "function") selectedCallback(pu, marker);
  }
  
  ns.automap = function() {
    var collection = $("#" + ns.listingID + " ." + ns.listingClass);
    if(collection.size() > 0) {
      ns.autoAddPickups(collection);
      var map = ns.getMap();
      var selectedKey = "data-" + ns.dataPrefix + "selected"
      var selected = collection.filter("[" + selectedKey + "]");
      if(selected.size() > 0) {
        var value = Number(selected.attr(selectedKey));
        if(value > 0) ns.selectPickup(value);
      }
      return map;
    }
  };
  
  $(document).ready(function() {
    ns.automap();
    if(map) ns.onEachPickupEvent('click', ns.selectPickup);
  });
  
});