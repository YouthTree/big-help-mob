Shuriken.defineExtension(function(baseNS) {
  return baseNS.withNS('Mixins', function(ns) {
    var defineMixin, root;
    root = this.getRootNS();
    ns.mixins = {};
    root.mixins = {};
    root.withBase(function(base) {
      base.mixin = function(mixins) {
        return ns.mixin(this, mixins);
      };
      return base.mixin;
    });
    defineMixin = function(key, mixin) {
      this.mixins[key] = mixin;
      return this.mixins[key];
    };
    root.defineMixin = defineMixin;
    ns.define = defineMixin;
    ns.lookupMixin = function(mixin) {
      var _a, _b, _c;
      if ((_a = typeof mixin) === "string") {
        if ((typeof (_b = ns.mixins[mixin]) !== "undefined" && _b !== null)) {
          return ns.mixins[mixin];
        } else if ((typeof (_c = root.mixins[mixin]) !== "undefined" && _c !== null)) {
          return root.mixins[mixin];
        } else {
          return {};
        }
      } else {
        return mixin;
      }
    };
    ns.invokeMixin = function(scope, mixin) {
      var _a;
      if ((_a = typeof mixin) === "string") {
        return ns.invokeMixin(scope, ns.lookupMixin(mixin));
      } else if (_a === "function") {
        return mixin.call(scope, scope);
      } else if (_a === "object") {
        return $.extend(scope, mixin);
      }
    };
    ns.mixin = function(scope, mixins) {
      var _a, _b, _c, mixin;
      if (!($.isArray(mixins))) {
        mixins = [mixins];
      }
      _b = mixins;
      for (_a = 0, _c = _b.length; _a < _c; _a++) {
        mixin = _b[_a];
        ns.invokeMixin(scope, ns.lookupMixin(mixin));
      }
      return true;
    };
    return ns.mixin;
  });
});