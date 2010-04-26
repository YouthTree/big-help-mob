BHM.withNS 'Admin.PostcodeMapper', (ns) ->
  
  ns.listSelector: '#user-location-list'
  ns.itemSelector: 'li'
  ns.mapSelector:  '#user-locations-map'
  ns.mapOptions:   {
    zoom:        10
    mapTypeId:   google.maps.MapTypeId.ROADMAP
    scrollwheel: false
  }
  
  # Inner data.
  postcodes: []
  map:       null
  
  class ns.Postcode
    
    constructor: (postcode, lat, lng, count) ->
      @postcode: postcode
      @lat:      lat
      @lng:      lng
      @count:    count
      @title:    "$count people from $postcode"
    
    toLatLng: ->
      @__latlng?= new google.maps.LatLng @lat, @lng
    
    toMarker: (map, opts) ->
      opts?= {}
      options: $.extend {}, opts
      options.title:    @title
      options.position: @toLatLng()
      options.map:      map
      new google.maps.Marker options
    
  
  ns.addPostcode: (postcode, lat, lng, count) ->
    postcodes.push new ns.Postcode(postcode, lat, lng, count)
  
  ns.autoAddPostcodes: ->
    $("$ns.listSelector $ns.itemSelector").each ->
      element: $ this
      ns.addPostcode ns.data(element, "postcode"),
                     Number(ns.data(element, "postcode-lat")),
                     Number(ns.data(element, "postcode-lng")),
                     Number(ns.data(element, "postcode-count"))
  
  ns.getMap: ->
    return map if map?
    container: $ ns.mapSelector
    container.addClass('dynamic-google-map').removeClass('static-google-map').empty()
    map: new google.maps.Map container.get(0), ns.mapOptions
  
  ns.addMarkers: ->
    currentMap: @getMap()
    @bounds?= new google.maps.LatLngBounds()
    markers: []
    for postcode in postcodes
      markers.push postcode.toMarker currentMap for i in [0..postcode.count]
      @bounds.extend postcode.toLatLng()
    cluster: new MarkerClusterer currentMap, markers
    currentMap.setCenter @bounds.getCenter()
    currentMap.fitBounds @bounds
    
  ns.setup: ->
    ns.autoAddPostcodes()
    ns.addMarkers()