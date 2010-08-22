var __slice = Array.prototype.slice;
Shuriken.defineExtension(function(baseNS) {
  return baseNS.defineMixin('Callbacks', function(mixin) {
    mixin.callbacks = {};
    mixin.defineCallback = function(key) {
      this[("on" + (key))] = function(callback) {
        return this.hasCallback(key, callback);
      };
      this[("invoke" + (key))] = function() {
        var args;
        args = __slice.call(arguments, 0);
        return this.invokeCallbacks.apply(this, [key].concat(args));
      };
      return true;
    };
    mixin.hasCallback = function(name, callback) {
      var callbacks;
      callbacks = mixin.callbacks[name] = (typeof mixin.callbacks[name] !== "undefined" && mixin.callbacks[name] !== null) ? mixin.callbacks[name] : [];
      callbacks.push(callback);
      return true;
    };
    mixin.callbacksFor = function(name) {
      var existing;
      existing = mixin.callbacks[name];
      return (typeof existing !== "undefined" && existing !== null) ? existing : [];
    };
    return (mixin.invokeCallbacks = function(name) {
      var _a, _b, _c, args, callback;
      args = __slice.call(arguments, 1);
      _b = mixin.callbacksFor(name);
      for (_a = 0, _c = _b.length; _a < _c; _a++) {
        callback = _b[_a];
        if (callback.apply(this, args) === false) {
          return false;
        }
      }
      return true;
    });
  });
});