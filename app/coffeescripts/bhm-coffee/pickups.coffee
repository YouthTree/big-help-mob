BHM.withNS 'Pickups', (ns) ->

  # State
  map:        null
  bounds:     null
  lastMarker: null
  lastWindow: null
  selected:   null
  
  # Datastructures.
  pickups:   {} # Each pickup point.
  markers:   {} # Each marker point.
  callbacks: [] # Callbacks for when pickups are selected.

  # Configuration
  
  ns.containerSelector: "#pickups-map"
  ns.listingSelector:   "#pickups-listing"
  ns.entrySelector:     ".pickup-entry"
  ns.defaultMapOptions: {
    zoom:        10
    mapTypeId:   google.maps.MapTypeId.ROADMAP
    scrollwheel: false
  };

  # Pickup Datastructure.
  
  class ns.Pickup
    
    constructor: (id, name, address, lat, lng, at, comment) ->
      @id:       id
      @name:     name
      @address:  address
      @lat:      lat
      @lng:      lng
      @pickupAt: at
      @comment:  comment
    
    toString: ->
      string: "$@name ($@address)"
      string+= ", pickup at $@pickupAt" if @pickupAt?
      string
    
    toLatLng: ->
      @_ll?= new google.maps.LatLng @lat, @lng
    
    toMarker: (map) ->
      options: {
        title:    @toString()
        position: @toLatLng()
        map:      map
      }
      new google.maps.Marker options
      
    toInfoWindow: (map, marker) ->      
      info: new google.maps.InfoWindow()
      # Create inner.
      inner: $ "<div />"
      inner.append $("<strong />").text(@name)
      inner.append $("<br />")
      inner.append $("<span />", {'class': 'address'}).text(@address)
      if @pickupAt?
        inner.append $("<br />")
        inner.append $("<span />", {'class': 'pickup-at'}).text("Pickup at $@pickupAt")
      if @comment?
        inner.append $("<br />")
        inner.append $("<span />", {'class': 'pickup-comment'}).text(@comment)
      # Actually show it.
      info.setContent inner.get(0)
      info.open map, marker
      info
  
  markerURL: (selected) ->
    suffix: if selected then "_green" else ""
    "http://www.google.com/intl/en_ALL/mapfiles/marker${suffix}.png"
  
  # Public API.
  
  ns.onPickupSelect: (callback) ->
    callbacks.push callback if $.isFunction callback
    
  ns.selectPickup: (pickup, clearWindow) ->
    lastWindow.close() if clearWindow and lastWindow?
    pickup: ns.getPickup pickup if typeof pickup is "number"
    return unless pickup?
    marker: ns.getMarker pickup.id
    return unless marker?
    lastMarker.setIcon markerURL(false) if lastMarker?
    marker.setIcon markerURL(true)
    lastMarker: marker
    for callback in callbacks
      callback pickup
    true
      
  
  ns.eachPickup: (callback) ->
    $.each pickups, -> callback @
    
  ns.getPickup: (id) ->
    pickups[id]
    
  ns.getMarker: (pickup) ->
    pickup: pickup.id if pickup.id?
    markers[pickup]
  
  ns.getMap: ->
    if not map?
      options: $.extend {}, ns.defaultMapOptions
      container: $ ns.containerSelector
      BHM.Maps.makeDynamic container
      map: new google.maps.Map container.get(0), options
    map
    
  ns.getBounds: ->
    bounds?= new google.maps.LatLngBounds()
  
  ns.addAllPickups: ->
    container: $("$ns.listingSelector $ns.entrySelector")
    container.each ->
      element: $ this
      if ns.hasData element, "pickup-id"
        id:      Number ns.data element, "pickup-id"
        lat:     Number ns.data element, "pickup-latitude"
        lng:     Number ns.data element, "pickup-longitude"
        name:    ns.data element, "pickup-name"
        address: ns.data element, "pickup-address"
        at:      ns.data element, "pickup-at"
        comment: ns.data element, "pickup-comment"
        pickups[id]: new ns.Pickup id, name, address, lat, lng, at, comment
    selected: container.filter "[data-$ns.dataPrefix-selected]"
  
  ns.plotPickups: ->
    map:    ns.getMap()
    bounds: ns.getBounds()
    ns.eachPickup (pickup) ->
      marker: pickup.toMarker map
      markers[pickup.id]: marker
      bounds.extend pickup.toLatLng()
      BHM.Maps.on 'click', marker, ->
        ns.selectPickup pickup, true
        lastWindow: pickup.toInfoWindow map, marker
    ns.centreMap()
    
  ns.centreMap: ->
    map:    ns.getMap()
    bounds: ns.getBounds()
    map.setCenter   bounds.getCenter()
    map.panToBounds bounds
    map.fitBounds   bounds
    
  ns.plot: ->
    ns.getMap()
    ns.plotPickups()
    
  ns.autoplot: ->
    ns.addAllPickups()
    ns.plot()
  
  # Setup tools.
    
  ns.setup: -> ns.autoplot()