var BHM;
if(!BHM) BHM = {};

(function(ns, $) {
  
  var defaultNSAttrs = {};
  
  var makeNS = function(o) {
    return $.extend(o, defaultNSAttrs);
  };
  
  var withNS = function(key, closure) {
    var parts = key.split(".");
    var currentNS = this;
    for(var i = 0; i < parts.length; i++) {
      var name = parts[i];
      if(!currentNS[name]) currentNS[name] = makeNS({});
      currentNS = currentNS[name];
    }
    if(typeof(closure) == "function") closure(currentNS);
    return currentNS;
  };
  
  var defineClass = function(name, closure) {
    var klass = function() {
      // Call the constructor.
      if(typeof(this.initialize) == "function") this.initialize.apply(this,  arguments);
    };
    if(typeof(closure) == "function") closure.call(klass.prototype, klass.prototype)
    this[name] = klass;
    return klass;
  };
  
  defaultNSAttrs.withNS      = withNS;
  defaultNSAttrs.defineClass = defineClass;
  // Actually make us a namespace.
  makeNS(ns);
  
})(BHM, jQuery);

