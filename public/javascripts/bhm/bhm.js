var BHM;
if(!BHM) BHM = {};

(function(ns, $) {
  
  var defaultNSAttrs = {};
  var onReadyMapping = {};
  
  var baseJSPath   = '/javascripts/';
  ns.baseJSSuffix = ''; 
  
  var makeNS = function(o, name, parent) {
    var obj = $.extend(o, defaultNSAttrs);
    obj.currentNamespaceKey  = name;
    obj.parentNamespace      = parent;
    return obj;
  };
  
  var underscoreString = function(s) {
    return s.replace(/\./g, '/').replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2').replace(/([a-z\d])([A-Z])/g, '$1_$2').replace(/-/g, '_').toLowerCase();
  };
  
  ns.underscoreString = underscoreString;
  
  var toNSName = function() {
    var parts = [];
    var current = this;
    while(current) {
      parts.unshift(current.currentNamespaceKey);
      current = current.parentNamespace;
    }
    return parts.join('.');
  };
  
  var withNS = function(key, closure) {
    var parts = key.split(".");
    var currentNS = this;
    for(var i = 0; i < parts.length; i++) {
      var name = parts[i];
      if(!currentNS[name]) currentNS[name] = makeNS({}, name, currentNS);
      currentNS = currentNS[name];
    }
    var hadSetup = (typeof(currentNS.setup) == "function");
    if(typeof(closure) == "function") closure(currentNS);
    if(!hadSetup && typeof(currentNS.setup) == "function")
      ns.setupVia(currentNS.setup);
    return currentNS;
  };
  
  var isNSDefined = function(key) {
    var parts = key.split(".");
    var currentNS = this;
    for(var i = 0; i < parts.length; i++) {
      var name = parts[i];
     if(!currentNS[name]) return false;
     currentNS = currentNS[name];
    }
    return true;
  };
  
  var require = function(name, path) {
    if(!this.isNSDefined(name)) {
      if(!path) path = ns.underscoreString(this.toNSName() + "." + name);
      var url = baseJSPath + path + ".js" + ns.baseJSSuffix;
      var script = document.createElement('script');
      script.type = "text/javascript";
      script.src  = url;
      var head = document.getElementsByTagName('head')[0];
      head.appendChild(script);
      return $(script);
    } else {
      var e = function(c) { c(); };
      return {
        load:  e,
        ready: e
      };
    }
  };
  
  var setupVia = function(f) {
    var scope = this;
    $(document).ready(function() {
      if(scope.autosetup && typeof(f) == "function") f.apply(this);
    });
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
  defaultNSAttrs.isNSDefined = isNSDefined;
  defaultNSAttrs.require     = require;
  defaultNSAttrs.toNSName    = toNSName;
  defaultNSAttrs.setupVia    = setupVia;
  defaultNSAttrs.autosetup   = true;
  
  // Actually make us a namespace.
  makeNS(ns, 'BHM');
  
})(BHM, jQuery);

