BHM.withNS 'Pickups', (ns) ->
  
  # Setup the default variables.
  map:              null
  mapBounds:        null
  lastSelected:     null
  lastInfoWindow:   null
  selectedCallback: null
  
  # Other misc data.
  pickups:         {}
  markers:         {}
  startLetter:     65
  iconOffset:      0
  imagePathPrefix: "http://www.google.com/intl/en_ALL/mapfiles/"
  
  # Exposed options
  
  ns.containerID:  "pickups-map"
  ns.listingID:    "pickups-listing"
  ns.listingClass: "pickup-entry"
  ns.dataPrefix:   "pickup-"
  
  # Map options...
  ns.defaultMapOptions: {
    zoom:        10
    mapTypeId:   google.maps.MapTypeId.ROADMAP
    scrollwheel: false
  }
  
  class ns.Pickup
    
    constructor: (id, name, address, lat, lng, at, comment) ->
      @id:      id
      @name:    name
      @address: address
      @lat:     lat
      @lng:     lng
      @at:      at
      @comment: comment
      @title:   "$name $address"
      
    toString: ->
      string: "$@name - $@address (Pickup ID #$@id) - ($@lat,$@lng"
      string += " Y $@at" if @hasPickupAt()
      string += ")"
      string
    
    hasPickupAt: ->
      @at? and "$@at" isnt ""
    
    hasComment: ->
      @comment? and "$@comment" isnt ""
      
    toMarker: (map, opts) ->
      opts?= {}
      options:          $.extend {}, opts
      options.title:    @title
      options.position: @toLatLng()
      options.map:      map
      new google.maps.Marker options
    
    toLatLng: ->
      @__latlng?= new google.maps.LatLng @lat, @lng
    
    toInfoWindow: (map, marker) ->
      infoWindow: new google.maps.InfoWindow()
      inner: $ "<div />"
      inner.append $("<strong />").text(@name)
      inner.append $("<br />")
      inner.append $("<span />", {'class': 'address'}).text(@address)
      if @hasPickupAt()
        inner.append $("<br />")
        inner.append $("<span />", {'class': 'pickup-at'}).text("Pickup at $@at")
      if @hasComment()
        inner.append $("<br />")
        inner.append $("<span />", {'class': 'pickup-comment'}).text(@comment)
      infoWindow.setContent inner.get(0)
      infoWindow.open map, marker
      infoWindow
  
  addPickupToPlot: (pickup) ->
    givePickupNumber pickup
    map:    ns.getMap()
    marker: pickup.toMarker map
    ns.getBounds().extend pickup.toLatLng()
    markers[pickup.id]: marker
    ns.onEvent m, 'click', ->
      lastInfoWindow.close() if lastInfoWindow?
      lastInfoWindow: pickup.toInfoWindow(map, marker)
    marker
  
  pickupAttr: (element, attr) ->
    ns.data element, "${ns.dataPrefix}$attr"
    
  givePickupNumber: (pu) ->
    pu.iconOffset?= iconOffset++
    pu.iconOffset
  
  markerWithImagePath: (pu, path) ->
    path: "$imagePathPrefix$path${lookupCharForOffset(pu.iconOffset)}.png"
    new google.maps.MarkerImage path
  
  lookupCharForOffset: (offset) ->
    String.fromCharCode startLetter + (offset % 26)
    
  normalMarkerImage:   (pu) -> markerImageWithPath pu, "marker"
  selectedMarkerImage: (pu) -> markerImageWithPath pu, "marker_green"
  
  ns.addPickup: (args...) ->
    pickup: new ns.Pickup args...
    pickups[pickup.id]: pickup
    addPickupToPlot pickup if map?
    pickup
    
  ns.onEvent: (object, name, handler) ->
    google.maps.event.addListener object, name, handler
    
  ns.onMapEvent: (name, handler) ->
    ns.onEvent ns.getMap(), name, handler
  
  ns.onPickupEvent: (id, name, handler) ->
    marker: ns.getPickupMarker id
    ns.onEvent marker, name, handler if marker?
  
  ns.onEachPickupEvent: (name, handler) ->
    ns.eachPickup: (pu) ->
      ns.onPickupEvent pu.id, name, -> handler(pu, arguments...)
  
  ns.onPickupSelect: (callback) ->
    selectedCallback: callback
  
  ns.getContainer: ->
    document.getElementById ns.containerID
  
  ns.getMap: ->
    ns.plot()
    map
  
  ns.getBounds: -> mapBounds?= new google.maps.LatLngBounds()
  
  ns.getPickup:       (id) -> pickups[id]
  ns.getPickupMarker: (id) -> markers[id]
  
  ns.autoAddPickups: (elements) ->
    elements?= $("#$ns.listingID .$ns.listingClass")
    elements.each ->
      element: $ this
      id: pickupAttr element, "id"
      if id?
        name:    pickupAttr element, "name"
        address: pickupAttr element, "address"
        lat:     Number pickupAttr element, "latitude"
        lng:     Number pickupAttr element, "longitude"
        at:      pickupAttr element, "at"
        comment: pickupAttr element, "comment"
        ns.addPickup Number(id), name, address, lat, lng,at, comment
  
  ns.centreMap: ->
    map:    ns.getMap()
    bounds: ns.getBounds()
    map.setCenter   bounds.getCenter()
    map.fitBounds   bounds
  
  ns.selectPickup: (pickup, clearWindow) ->
    lastInfoWindow.close() if clearWindow? and lastInfoWindow?
    pickup: ns.getPickup(pickup) if typeof pickup is "number"
    return unless pickup?
    marker: markers[pickup.id]
    markers[lastSelected.id].setIcon normalMarkerImage(lastSelected) if lastSelected?
    lastSelect: pickup
    marker.setIcon selectedMarkerImage(pickup)
    selectedCallback pickup, marker if $.isFunction selectedCallback
  
  ns.automap: ->
    collection: "#$ns.listingID .$ns.listingClass"
    if collection.size() > 0
      ns.autoAddPickups collection
      map: ns.getMap()
      selectedKey: "data-${ns.dataPrefix}selected"
      selected: collection.filter "[$selectedKey]"
      if selected.size() > 0
        value: Number selected.attr selectedKey
        ns.selectPickup value if value > 0
      map
    
  ns.plot: (options) ->
    return map if map?
    options?= {}
    container: ns.getContainer()
    return unless container?
    mapOptions: $.extend {}, options, ns.defaultMapOptions
    $(c).addClass('dynamic-google-map').removeClass('static-google-map').empty()
    map: new google.maps.Map(container, mapOptions)
    ns.eachPickup: addPickupToPlot
    ns.centreMap()
    map
  
  ns.eachPickup: (f) ->
    f(pickup) for pickup in pickups
  
  ns.setup: ->
    ns.automap()
    ns.onEachPickupEvent 'click', ns.selectPickup if map?
    
    