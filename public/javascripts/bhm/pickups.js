/**
 * BHM.Pickups
 * -----------
 * unobtrusively generates a dynamic google map of pickup points
 * from html5 w/ data attributes. Designed to make it uber simple
 * for users to select pickups in a more interactive manner. 
 */
BHM.withNS('Pickups', function(ns) {
  
  // Section: Private Variables / Configuration
  
  var map, mapBounds, lastSelected, lastInfoWindow, selectedCallback;  
  var pickups         = {},
      markers         = {},
      startLetter     = 65,
      iconOffset      = 0, 
      imagePathPrefix = "http://www.google.com/intl/en_ALL/mapfiles/";
  
  // Section: Public Options / Configuration
  
  ns.containerID       = "pickups-map";
  ns.listingID         = "pickups-listing";
  ns.listingClass      = "pickup-entry";
  ns.dataPrefix        = "pickup-";
  ns.defaultMapOptions = {
    zoom:        10,
    mapTypeId:   google.maps.MapTypeId.ROADMAP,
    scrollwheel: false
  };
  
  // Section: Classes
  
  ns.defineClass('Pickup', function() {
    
    this.initialize = function(id, name, address, lat, lng, at) {
      this.name    = name;
      this.address = address;
      this.at      = at;
      this.title   = name + " " + address;
      this.id      = id;
      this.lat     = lat;
      this.lng     = lng;
      this.at      = at;
    };
    
    this.toString = function() {
      var s = "" + this.name + " - " + this.address;
      s += " (Pickup ID #" + this.id + ")";
      s += "(" + this.lat + ", " + this.lng
      if(this.hasPickupAt()) s += " Y " + this.at;
      s += ")";
      return s;
    }
    
    this.hasPickupAt = function() {
      return this.at && this.at.toString().length > 0;
    }
    
    this.toMarker = function(map, options) {
      if(!options) options = {};
      var o      = $.extend({}, options);
      o.title    = this.title;
      o.position = this.toLatLng();
      o.map      = map;
      return new google.maps.Marker(o);
    }
    
    this.toLatLng = function() {
      if(!this.__latlng)
        this.__latlng = new google.maps.LatLng(this.lat, this.lng);
      return this.__latlng;
    }
    
    this.toInfoWindow = function(map, marker) {
      var infoWindow = new google.maps.InfoWindow();
      var inner = $("<div />");
      inner.append($("<strong />").text(this.name));
      inner.append("<br />");
      inner.append($("<span />").addClass('address').text(this.address));
      if(this.hasPickupAt()) {
        inner.append("<br />");
        inner.append("Pickup at " + this.at);
      }
      infoWindow.setContent(inner.get(0));
      infoWindow.open(map, marker);
      return infoWindow;
    }
    
  });
  
  // Section: Utility Methods
  
  function addPickupToPlot(pickup) {
    givePickupNumber(pickup);
    var map = ns.getMap();
    var m = pickup.toMarker(map, {icon: normalMarkerImage(pickup)});
    var b = ns.getBounds();
    b.extend(pickup.toLatLng());
    markers[pickup.id] = m;
    ns.onEvent(m, 'click', function() {
      if(lastInfoWindow) lastInfoWindow.close();
      lastInfoWindow = pickup.toInfoWindow(map, m);
    });
    return m;
  }
  
  function pickupAttr(e, key) {
    return e.attr("data-" + ns.dataPrefix + key);
  }
  
  function givePickupNumber(pu) {
    if(!pu.iconOffset) pu.iconOffset = iconOffset++;
    return pu.iconOffset;
  }
  
  function markerImageWithPath(pu, path) {
    path = imagePathPrefix + path + lookupCharForOffset(pu.iconOffset) + ".png";
    return new google.maps.MarkerImage(path);
  }
  
  function lookupCharForOffset(offset) {
    return String.fromCharCode(startLetter + (offset % 26));
  }
  
  function normalMarkerImage(pu) {
    return markerImageWithPath(pu, "marker");
  }
  
  function selectedMarkerImage(pu) {
    return markerImageWithPath(pu, "marker_green");
  }
  
  // Section: Namespace Methods
  
  // Subsection: Modifiers
  
  ns.addPickup = function(id, name, address, lat, lng, at) {
    var p = new ns.Pickup(id, name, address, lat, lng, at);
    pickups[p.id] = p;
    if(map) addPickupToPlot(p);
    return p;
  };
  
  // Subsection: Event Methods
  
  ns.onEvent           = function(obj, name, handler) {
    google.maps.event.addListener(obj, name, handler);
  };
  
  ns.onMapEvent        = function(name, handler) {
    return ns.onEvent(ns.getMap(), name, handler);
  };
  
  ns.onPickupEvent     = function(id, name, handler) {
    var m = ns.getPickupMarker(id);
    if(m) return ns.onEvent(m, name, handler);
  };
  
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
  };
  
  ns.onPickupSelect    = function(cb) {
    selectedCallback = cb;
  };
  
  // Subsection: Accessors
  
  ns.getContainer    = function() {
    return document.getElementById(ns.containerID);
  };
  
  ns.getMap          = function() {
    ns.plot();
    return map;
  };
  
  ns.getBounds       = function() {
    if(!mapBounds) mapBounds = new google.maps.LatLngBounds();
    return mapBounds;
  };
  
  ns.getPickup       = function(id) {
    return pickups[id];
  };
  
  ns.getPickupMarker = function(id) {
    var pu = ns.getPickup(id);
    if(pu) return markers[id];
  };
  
  // Subsection: Map Utilities
  
  ns.autoAddPickups = function(c) {
    if(!c) c = $("#" + ns.listingID + " ." + ns.listingClass);
    c.each(function() {
      var e = $(this);
      var id = pickupAttr(e, "id");
      if(id) {
        var name  = pickupAttr(e, "name"),
            addr  = pickupAttr(e, "address"),
            lat   = Number(pickupAttr(e, "latitude")),
            lng   = Number(pickupAttr(e, "longitude")),
            at    = pickupAttr(e, "at");
        ns.addPickup(Number(id), name, addr, lat, lng, at);
      };
    });
  };
  
  ns.centreMap      = function() {
    var m = ns.getMap();
    var b = ns.getBounds();
    m.setCenter(b.getCenter());
    m.panToBounds(b);
    m.fitBounds(b);
  };
  
  ns.selectPickup   = function(pu, clearWindow) {
    if(lastInfoWindow && clearWindow === true) lastInfoWindow.close();
    if(typeof(pu) == "number") pu = ns.getPickup(pu);
    if(!pu) return;
    var marker = markers[pu.id];
    if(lastSelected) markers[lastSelected.id].setIcon(normalMarkerImage(lastSelected));
    lastSelected = pu;
    marker.setIcon(selectedMarkerImage(pu));
    if(typeof(selectedCallback) == "function") selectedCallback(pu, marker);
  };
  
  ns.automap        = function() {
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
  
  ns.plot           = function(options) {
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
  
  ns.plotDirections = function(origin, pickups) {
  };
  
  // Subsection: Misc.  
  
  ns.eachPickup = function(f) {
    for(var idx in pickups) {
      if(pickups.hasOwnProperty(idx)) f(pickups[idx]);
    }
  };
  
  ns.setup      = function() {
    ns.automap();
    if(map) ns.onEachPickupEvent('click', ns.selectPickup);
  };
  
});