BHM.withNS('Mixins', function(ns) {
  var defineMixin;
  ns.mixins = {};
  BHM.mixins = {};
  BHM.extendBase(function(base) {
    base.mixin = function mixin(mixins) {
      return ns.mixin(this, mixins);
    };
    return base.mixin;
  });
  defineMixin = function defineMixin(key, mixin) {
    this.mixins[key] = mixin;
    return this.mixins[key];
  };
  BHM.defineMixin = defineMixin;
  ns.define = defineMixin;
  ns.lookupMixin = function lookupMixin(mixin) {
    var _a, _b, _c;
    if ((_a = typeof mixin) === "string") {
      if ((typeof (_b = ns.mixins[mixin]) !== "undefined" && _b !== null)) {
        return ns.mixins[mixin];
      } else if ((typeof (_c = BHM.mixins[mixin]) !== "undefined" && _c !== null)) {
        return BHM.mixins[mixin];
      } else {
        return {};
        // unknown mixin, return a blank object.
      }
    } else {
      return mixin;
    }
  };
  ns.invokeMixin = function invokeMixin(scope, mixin) {
    var _a;
    if ((_a = typeof mixin) === "string") {
      return ns.invokeMixin(scope, ns.lookupMixin(mixin));
    } else if (_a === "function") {
      return mixin.call(scope, scope);
    } else if (_a === "object") {
      return $.extend(scope, mixin);
    }
  };
  ns.mixin = function mixin(scope, mixins) {
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