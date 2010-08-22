BHM.withNS('Maps', function(ns) {
  ns.dynamicClassName = 'dynamic-google-map';
  ns.staticClassName = 'static-google-map';
  ns.makeDynamic = function(element) {
    return $(element).removeClass(ns.staticClassName).addClass(ns.dynamicClassName).empty();
  };
  return (ns.on = function(name, object, callback) {
    return google.maps.event.addListener(object, name, callback);
  });
});