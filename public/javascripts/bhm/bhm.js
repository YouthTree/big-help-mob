var __slice = Array.prototype.slice;
Shuriken.as('BHM');
BHM.withBase(function(ns) {
  ns.data = function(element) {
    var _c, args;
    var _a = arguments.length, _b = _a >= 2;
    args = __slice.call(arguments, 1, _a - 0);
    return (_c = $(element)).dataAttr.apply(_c, args);
  };
  ns.hasData = function(element) {
    var _c, args;
    var _a = arguments.length, _b = _a >= 2;
    args = __slice.call(arguments, 1, _a - 0);
    return (_c = $(element)).hasDataAttr.apply(_c, args);
  };
  return ns.hasData;
});