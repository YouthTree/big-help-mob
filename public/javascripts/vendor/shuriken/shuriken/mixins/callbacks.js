var __slice = Array.prototype.slice;
Shuriken.defineExtension(function(baseNS) {
  return baseNS.defineMixin('Callbacks', function(mixin) {
    mixin.callbacks = {};
    mixin.defineCallback = function defineCallback(key) {
      this[("on" + key)] = function(callback) {
        return this.hasCallback(key, callback);
      };
      this[("invoke" + key)] = function() {
        var args;
        args = __slice.call(arguments, 0, arguments.length - 0);
        return this.invokeCallbacks.apply(this, [key].concat(args));
      };
      return true;
    };
    mixin.hasCallback = function hasCallback(name, callback) {
      var _a, callbacks;
      callbacks = mixin.callbacks[name] = (typeof (_a = mixin.callbacks[name]) !== "undefined" && _a !== null) ? mixin.callbacks[name] : [];
      callbacks.push(callback);
      return true;
    };
    mixin.callbacksFor = function callbacksFor(name) {
      var existing;
      existing = mixin.callbacks[name];
      if ((typeof existing !== "undefined" && existing !== null)) {
        return existing;
      } else {
        return [];
      }
    };
    mixin.invokeCallbacks = function invokeCallbacks(name) {
      var _a, _b, _c, args, callback;
      args = __slice.call(arguments, 1, arguments.length - 0);
      _b = mixin.callbacksFor(name);
      for (_a = 0, _c = _b.length; _a < _c; _a++) {
        callback = _b[_a];
        if (callback.apply(this, args) === false) {
          return false;
        }
      }
      return true;
    };
    return mixin.invokeCallbacks;
  });
});