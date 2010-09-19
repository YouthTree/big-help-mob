BHM.withNS('Debug', function(ns) {
  ns.getCurrentUUID = function() {
    var _a, _b, _c, _d, data, match, node, nodes;
    nodes = document.body.childNodes;
    _a = []; _c = nodes;
    for (_b = 0, _d = _c.length; _b < _d; _b++) {
      node = _c[_b];
      if (node.nodeName === "#comment") {
        data = node.data;
        match = data.match(/bhm-request-uuid:\s*(\S+)\s*/);
        if (typeof match !== "undefined" && match !== null) {
          return match[1];
        }
      }
    }
    return _a;
  };
  return (ns.showDebugInformation = function() {
    var uuid;
    uuid = ns.getCurrentUUID();
    if (typeof uuid !== "undefined" && uuid !== null) {
      return alert("Current Request UUID: " + (uuid));
    }
  });
});