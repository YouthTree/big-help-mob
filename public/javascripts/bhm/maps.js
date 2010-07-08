BHM.withNS('Maps', function(ns) {
  ns.dynamicClassName = 'dynamic-google-map';
  ns.staticClassName = 'static-google-map';
  ns.makeDynamic = function makeDynamic(element) {
    return $(element).removeClass(ns.staticClassName).addClass(ns.dynamicClassName).empty();
  };
  ns.on = function on(name, object, callback) {
    return google.maps.event.addListener(object, name, callback);
  };
  return ns.on;
});