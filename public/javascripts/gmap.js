var GMap = (function($) {
  var map              = {};
  var mapOptionKeys    = ["zoom", "title"];
  var markerOptionKeys = ["title"];
  
  // Map options
  map.count          = 0;
  map.autoIDPrefix   = "gmap-";
  map.maps           = [];
  map.defaultOptions = {
    zoom:        15,
    mapTypeId:   google.maps.MapTypeId.ROADMAP
    scrollwheel: false
  };
  
  function mergeOptionsWithData(element, options, keys, spacer) {
    if(!spacer) spacer = "";
    for(var i = 0; i < keys.length; i++) {
      var key = keys[i];
      var dataKey = "data-" + spacer + key;
      if(element.is("[" + dataKey + "]")) options[key] = element.attr(dataKey);
    }
  }
  
  function mapOptionsForElement(element) {
    var options = $.extend({}, map.defaultOptions);
    mergeOptionsWithData(element, options, mapOptionKeys)
    return options;
  }
  
  map.install = function() {
    $('.gmap').each(map.setupElement)
  };
  
  map.setupElement = function() {
    var e = this;
    var $e = $(this);
    var id = $e.attr("id");
    // Autogenerate id.
    if(!id) {
      id = map.autoIDPrefix + (map.count++);
      $e.attr("id", id);
    }
    var lat = Number($e.attr("data-latitude"));
    var lng = Number($e.attr("data-longitude"));
    var point = new google.maps.LatLng(lat, lng);
    // Create the Map.
    var mapOptions = mapOptionsForElement($e);
    mapOptions.center = point;
    // Add a class for general styling and empty it out.
    $e.empty();
    $e.addClass('dynamic-google-map').removeClass('static-google-map');
    var currentMap = new google.maps.Map(e, mapOptions);
    // Create and add the marker
    var markerOptions = {
      position: point,
      map:      currentMap
    };
    mergeOptionsWithData($e, markerOptions, markerOptionKeys, "marker-");
    var marker = new google.maps.Marker(markerOptions)
    // And Done...
    return currentMap;
  };
  
  $(document).ready(function() { map.install(); });
  return map;
})(jQuery);