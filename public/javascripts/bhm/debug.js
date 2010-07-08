BHM.withNS('Debug', function(ns) {
  ns.getCurrentUUID = function getCurrentUUID() {
    var _a, _b, _c, data, match, node, nodes;
    nodes = document.body.childNodes;
    _b = nodes;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      node = _b[_a];
      if (node.nodeName === "#comment") {
        data = node.data;
        match = data.match(/bhm-request-uuid:\s*(\S+)\s*/);
        if ((typeof match !== "undefined" && match !== null)) {
          return match[1];
        }
      }
    }
  };
  ns.showDebugInformation = function showDebugInformation() {
    var uuid;
    uuid = ns.getCurrentUUID();
    if ((typeof uuid !== "undefined" && uuid !== null)) {
      return alert(("Current Request UUID: " + uuid));
    }
  };
  return ns.showDebugInformation;
});