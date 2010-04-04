BHM.withNS('Mission', function(ns) {
  
  ns.setup = function() {
    $('#pickups-listing li abbr').tipsy({
      gravity: 'e',
      title:   function() { return this.getAttribute("original-title").replace(/,/g, '<br />'); },
      fade:    true,
      html:    true
    });
  };
  
});