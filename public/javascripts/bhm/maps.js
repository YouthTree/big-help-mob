BHM.withNS('Maps', function(ns) {
  
  function toRad() {
    return this * Math.PI / 180;
  }
  
  var R = 6371;
  
  ns.sortDistances = function(centerPoint, collection, mapFunc) {
    if(!mapFunc) mapFunc = function(c) { return c; };
    return collection.sort(function(a, b) {
      var realA = mapFunc(a),
          realB = mapFunc(b),
          realC = mapFunc(centerPoint);
      return ns.distanceBetween(realC, realA) - ns.distanceBetween(realC, realB);
    });
  };
  
  // Using the Haversinces formula. Returns a result in kilometres.
  // Code from http://www.movable-type.co.uk/scripts/latlong.html
  ns.distanceBetween = function(a, b) {
    var lat1 = a.lat(), lat2 = b.lat(),
        lng1 = a.lng(), lng2 = b.lng();
    var dLat = toRad(lat2 - lat1);
    var dLng = toRad(lng2 - lng2); 
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLng / 2) * Math.sin(dLng / 2); 
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return c * R;
  };
  
});