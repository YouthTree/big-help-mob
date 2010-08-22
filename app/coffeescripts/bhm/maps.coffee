BHM.withNS 'Maps', (ns) ->

  ns.dynamicClassName = 'dynamic-google-map'
  ns.staticClassName  = 'static-google-map'

  ns.makeDynamic = (element) ->
    $(element).removeClass(ns.staticClassName).addClass(ns.dynamicClassName).empty()
    
  ns.on = (name, object, callback) ->
    google.maps.event.addListener(object, name, callback)