BHM.withNS('Mission', function(ns) {
  ns.abbrselector = '#pickups-listing li abbr';
  ns.imgSelector = '#mission-photos a';
  return (ns.setup = function() {
    $(ns.abbrSelector).tipsy({
      title: function() {
        return this.getAttribute("original-title").replace(/,/g, "<br/>");
      },
      gravity: 'e',
      fade: true,
      html: true
    });
    return YouthTree.Gallery.create('mission-gallery', ns.imgSelector);
  });
});