var __slice = Array.prototype.slice, __bind = function(func, obj, args) {
    return function() {
      return func.apply(obj || {}, args ? args.concat(__slice.call(arguments, 0)) : arguments);
    };
  };
(function() {
  var Shuriken, base, makeNS, scopedClosure;
  // First off, add our dataAttr extensions.
  (typeof jQuery !== "undefined" && jQuery !== null) ? (function($) {
    var stringToDataKey;
    stringToDataKey = function stringToDataKey(key) {
      return ("data-" + key).replace(/_/g, '-');
    };
    $.fn.dataAttr = function dataAttr(key, value) {
      return this.attr(stringToDataKey(key), value);
    };
    $.fn.removeDataAttr = function removeDataAttr(key) {
      return this.removeAttr(stringToDataKey(key));
    };
    $.fn.hasDataAttr = function hasDataAttr(key) {
      return this.is(("[" + (stringToDataKey(key)) + "]"));
    };
    $.metaAttr = function metaAttr(key) {
      return $(("meta[name='" + key + "']")).attr("content");
    };
    return $.metaAttr;
  })(jQuery) : null;
  Shuriken = {
    Base: {},
    Util: {},
    jsPathPrefix: "/javascripts/",
    jsPathSuffix: "",
    namespaces: {},
    extensions: []
  };
  Shuriken.Util.underscoreize = function underscoreize(s) {
    return s.replace(/\./g, '/').replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2').replace(/([a-z\d])([A-Z])/g, '$1_$2').replace(/-/g, '_').toLowerCase();
  };
  scopedClosure = function scopedClosure(closure, scope) {
    if ($.isFunction(closure)) {
      return closure.call(scope, scope);
    }
  };
  // Base is the prototype for all namespaces.
  base = Shuriken.Base;
  base.hasChildNamespace = function hasChildNamespace(child) {
    return this.children.push(child);
  };
  base.toNSName = function toNSName() {
    var children, current, parts;
    children = __slice.call(arguments, 0, arguments.length - 0);
    parts = children;
    current = this;
    while ((typeof current !== "undefined" && current !== null)) {
      parts.unshift(current.name);
      current = current.parent;
    }
    return parts.join(".");
  };
  base.getNS = function getNS(namespace) {
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
  base.getRootNS = function getRootNS() {
    var _a, current;
    current = this;
    while ((typeof (_a = current.parent) !== "undefined" && _a !== null)) {
      current = current.parent;
    }
    return current;
  };
  base.hasNS = function hasNS(namespace) {
    var _a;
    return (typeof (_a = this.getNS(namespace)) !== "undefined" && _a !== null);
  };
  base.withNS = function withNS(key, initializer) {
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
  base.withBase = function withBase(closure) {
    return scopedClosure(closure, this.baseNS);
  };
  base.extend = function extend(closure) {
    return scopedClosure(closure, this);
  };
  base.isRoot = function isRoot() {
    var _a;
    return !(typeof (_a = this.parent) !== "undefined" && _a !== null);
  };
  base.log = function log() {
    var args;
    args = __slice.call(arguments, 0, arguments.length - 0);
    return console.log.apply(console, [("[" + (this.toNSName()) + "]")].concat(args));
  };
  base.debug = function debug() {
    var args;
    args = __slice.call(arguments, 0, arguments.length - 0);
    return console.log.apply(console, [("[Debug - " + (this.toNSName()) + "]")].concat(args));
  };
  base.setupVia = function setupVia(f) {
    return $(document).ready(__bind(function() {
        var _a;
        if ((typeof (_a = this.autosetup) !== "undefined" && _a !== null)) {
          return scopedClosure(f, this);
        }
      }, this));
  };
  base.require = function require(key, callback) {
    var ns, path, script, url;
    ns = this.getNS(key);
    if ((typeof ns !== "undefined" && ns !== null)) {
      return scopedClosure(callback, ns);
    } else {
      path = Shuriken.Util.underscoreize(("" + (this.toNSName()) + "." + key));
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
  // Used as a part of the prototype chain.
  Shuriken.Namespace = function Namespace() {  };
  Shuriken.Namespace.prototype = Shuriken.Base;
  makeNS = function makeNS(name, parent, sharedPrototype) {
    var namespace;
    sharedPrototype = (typeof sharedPrototype !== "undefined" && sharedPrototype !== null) ? sharedPrototype : new Shuriken.Namespace();
    namespace = function namespace() {
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
  Shuriken.defineExtension = function defineExtension(closure) {
    var _a, _b, _c, namespace;
    _b = Shuriken.namespaces;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      namespace = _b[_a];
      scopedClosure(closure, namespace);
    }
    return Shuriken.extensions.push(closure);
  };
  Shuriken.as = function as(name) {
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
  this['Shuriken'] = Shuriken;
  return this['Shuriken'];
})();