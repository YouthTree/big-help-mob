var __slice = Array.prototype.slice, __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  };
(function() {
  var Shuriken, base, makeNS, scopedClosure;
  if ((typeof jQuery !== "undefined" && jQuery !== null)) {
    (function($) {
      var stringToDataKey;
      stringToDataKey = function(key) {
        return ("data-" + (key)).replace(/_/g, '-');
      };
      $.fn.dataAttr = function(key, value) {
        return this.attr(stringToDataKey(key), value);
      };
      $.fn.removeDataAttr = function(key) {
        return this.removeAttr(stringToDataKey(key));
      };
      $.fn.hasDataAttr = function(key) {
        return this.is(("[" + (stringToDataKey(key)) + "]"));
      };
      return ($.metaAttr = function(key) {
        return $(("meta[name='" + (key) + "']")).attr("content");
      });
    })(jQuery);
  };
  Shuriken = {
    Base: {},
    Util: {},
    jsPathPrefix: "/javascripts/",
    jsPathSuffix: "",
    namespaces: {},
    extensions: []
  };
  Shuriken.Util.underscoreize = function(s) {
    return s.replace(/\./g, '/').replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2').replace(/([a-z\d])([A-Z])/g, '$1_$2').replace(/-/g, '_').toLowerCase();
  };
  scopedClosure = function(closure, scope) {
    if ($.isFunction(closure)) {
      return closure.call(scope, scope);
    }
  };
  base = Shuriken.Base;
  base.hasChildNamespace = function(child) {
    return this.children.push(child);
  };
  base.toNSName = function() {
    var children, current, parts;
    children = __slice.call(arguments, 0);
    parts = children;
    current = this;
    while ((typeof current !== "undefined" && current !== null)) {
      parts.unshift(current.name);
      current = current.parent;
    }
    return parts.join(".");
  };
  base.getNS = function(namespace) {
    var _a, _b, _c, _d, currentNS, name, parts;
    parts = namespace.split(".");
    currentNS = this;
    _b = parts;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      name = _b[_a];
      if (!((typeof (_d = currentNS[name]) !== "undefined" && _d !== null))) {
        return null;
      }
      currentNS = currentNS[name];
    }
    return currentNS;
  };
  base.getRootNS = function() {
    var _a, current;
    current = this;
    while ((typeof (_a = current.parent) !== "undefined" && _a !== null)) {
      current = current.parent;
    }
    return current;
  };
  base.hasNS = function(namespace) {
    var _a;
    return (typeof (_a = this.getNS(namespace)) !== "undefined" && _a !== null);
  };
  base.withNS = function(key, initializer) {
    var _a, _b, _c, _d, currentNS, hadSetup, name, parts;
    parts = key.split(".");
    currentNS = this;
    _b = parts;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      name = _b[_a];
      if (!(typeof (_d = currentNS[name]) !== "undefined" && _d !== null)) {
        currentNS[name] = makeNS(name, currentNS, this.baseNS);
      }
      currentNS = currentNS[name];
    }
    hadSetup = $.isFunction(currentNS.setup);
    scopedClosure(initializer, currentNS);
    if (!hadSetup && $.isFunction(currentNS.setup)) {
      currentNS.setupVia(currentNS.setup);
    }
    return currentNS;
  };
  base.withBase = function(closure) {
    return scopedClosure(closure, this.baseNS);
  };
  base.extend = function(closure) {
    return scopedClosure(closure, this);
  };
  base.isRoot = function() {
    var _a;
    return !(typeof (_a = this.parent) !== "undefined" && _a !== null);
  };
  base.log = function() {
    var args;
    args = __slice.call(arguments, 0);
    return console.log.apply(console, [("[" + (this.toNSName()) + "]")].concat(args));
  };
  base.debug = function() {
    var args;
    args = __slice.call(arguments, 0);
    return console.log.apply(console, [("[Debug: " + (this.toNSName()) + "]")].concat(args));
  };
  base.setupVia = function(f) {
    return $(document).ready(__bind(function() {
      var _a;
      if ((typeof (_a = this.autosetup) !== "undefined" && _a !== null)) {
        return scopedClosure(f, this);
      }
    }, this));
  };
  base.require = function(key, callback) {
    var ns, path, script, url;
    ns = this.getNS(key);
    if ((typeof ns !== "undefined" && ns !== null)) {
      return scopedClosure(callback, ns);
    } else {
      path = Shuriken.Util.underscoreize(("" + (this.toNSName()) + "." + (key)));
      url = ("" + (Shuriken.jsPathPrefix) + (path) + ".js" + (Shuriken.jsPathSuffix));
      script = $("<script />", {
        type: "text/javascript",
        src: url
      });
      script.load(function() {
        return scopedClosure(callback, this.getNS(key));
      });
      return script.appendTo($("head"));
    }
  };
  base.autosetup = true;
  Shuriken.Namespace = function() {};
  Shuriken.Namespace.prototype = Shuriken.Base;
  makeNS = function(name, parent, sharedPrototype) {
    var namespace;
    sharedPrototype = (typeof sharedPrototype !== "undefined" && sharedPrototype !== null) ? sharedPrototype : new Shuriken.Namespace();
    namespace = function() {
      this.name = name;
      this.parent = parent;
      this.baseNS = sharedPrototype;
      this.children = [];
      if ((typeof parent !== "undefined" && parent !== null)) {
        parent.hasChildNamespace(this);
      }
      return this;
    };
    namespace.prototype = sharedPrototype;
    return new namespace(name, parent);
  };
  Shuriken.defineExtension = function(closure) {
    var _a, _b, _c, namespace;
    _b = Shuriken.namespaces;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      namespace = _b[_a];
      scopedClosure(closure, namespace);
    }
    return Shuriken.extensions.push(closure);
  };
  Shuriken.as = function(name) {
    var _a, _b, _c, extension, ns;
    ns = makeNS(name);
    Shuriken.namespaces[name] = ns;
    Shuriken.root[name] = ns;
    _b = Shuriken.extensions;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      extension = _b[_a];
      scopedClosure(extension, ns);
    }
    return ns;
  };
  Shuriken.root = this;
  return (this['Shuriken'] = Shuriken);
})();