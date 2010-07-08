BHM.withNS('Mission', function(ns) {
  ns.selector = '#pickups-listing li abbr';
  ns.setup = function setup() {
    return $(ns.selector).tipsy({
      title: function title() {
        return this.getAttribute("original-title").replace(/,/g, '<br />');
      },
      gravity: 'e',
      fade: true,
      html: true
    });
  };
  return ns.setup;
});