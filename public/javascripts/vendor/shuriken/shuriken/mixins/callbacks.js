var __slice = Array.prototype.slice;
Shuriken.defineExtension(function(baseNS) {
  return baseNS.defineMixin('Callbacks', function(mixin) {
    mixin.callbacks = {};
    mixin.defineCallback = function(key) {
      this[("on" + key)] = function(callback) {
        return this.hasCallback(key, callback);
      };
      this[("invoke" + key)] = function() {
        var args;
        var _a = arguments.length, _b = _a >= 1;
        args = __slice.call(arguments, 0, _a - 0);
        return this.invokeCallbacks.apply(this, [key].concat(args));
      };
      return true;
    };
    mixin.hasCallback = function(name, callback) {
      var _a, callbacks;
      callbacks = mixin.callbacks[name] = (typeof (_a = mixin.callbacks[name]) !== "undefined" && _a !== null) ? mixin.callbacks[name] : [];
      callbacks.push(callback);
      return true;
    };
    mixin.callbacksFor = function(name) {
      var existing;
      existing = mixin.callbacks[name];
      return (typeof existing !== "undefined" && existing !== null) ? existing : [];
    };
    mixin.invokeCallbacks = function(name) {
      var _c, _d, _e, args, callback;
      var _a = arguments.length, _b = _a >= 2;
      args = __slice.call(arguments, 1, _a - 0);
      _d = mixin.callbacksFor(name);
      for (_c = 0, _e = _d.length; _c < _e; _c++) {
        callback = _d[_c];
        if (callback.apply(this, args) === false) {
          return false;
        }
      }
      return true;
    };
    return mixin.invokeCallbacks;
  });
});