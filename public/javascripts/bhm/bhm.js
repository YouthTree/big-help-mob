var __slice = Array.prototype.slice;
// Define the default BHM namespace
Shuriken.as('BHM');
BHM.withBase(function(ns) {
  ns.data = function data(element) {
    var _a, args;
    args = __slice.call(arguments, 1, arguments.length - 0);
    return (_a = $(element)).dataAttr.apply(_a, args);
  };
  ns.hasData = function hasData(element) {
    var _a, args;
    args = __slice.call(arguments, 1, arguments.length - 0);
    return (_a = $(element)).hasDataAttr.apply(_a, args);
  };
  return ns.hasData;
});