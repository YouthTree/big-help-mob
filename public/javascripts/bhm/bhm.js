var __slice = Array.prototype.slice;
Shuriken.as('BHM');
BHM.withBase(function(ns) {
  ns.data = function(element) {
    var _a, args;
    args = __slice.call(arguments, 1);
    return (_a = $(element)).dataAttr.apply(_a, args);
  };
  return (ns.hasData = function(element) {
    var _a, args;
    args = __slice.call(arguments, 1);
    return (_a = $(element)).hasDataAttr.apply(_a, args);
  });
});