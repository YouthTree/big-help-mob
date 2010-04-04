BHM.withNS('Debug', function(ns) {
  
  ns.getCurrentUUID = function() {
    var cn = document.body.childNodes;
    var uuid;
    for(var i = 0; i < cn.length; i++) {
      var n = cn[i];
      if(n.nodeName == "#comment") {
        var data = n.data;
        var m = data.match(/bhm-request-uuid:\s*(\S+)\s*/);
        if(m) return m[1];
      }
    }
  };
  
  ns.showDebugInformation = function() {
    var uuid = ns.getCurrentUUID();
    if(uuid) alert("Current Request UUID: " + uuid);
  };
  
});