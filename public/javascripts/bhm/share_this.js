BHM.withNS('ShareThis', function(ns) {
  ns.shareThisSelector = 'a.share-this';
  ns.getURL = function() {
    return document.location.href;
  };
  ns.getTitle = function() {
    return document.title;
  };
  ns.getEntry = function() {
    return SHARETHIS.addEntry({
      title: ns.getTitle(),
      url: ns.getURL()
    });
  };
  ns.attachEvents = function() {
    var entry;
    entry = ns.getEntry();
    return $(ns.shareThisSelector).show().click(function() {
      return false;
    }).each(function() {
      var destination;
      destination = ns.data($(this), "share-this-target");
      if (typeof destination !== "undefined" && destination !== null) {
        return entry.attachChicklet(destination, this);
      } else {
        return entry.attachButton(this);
      }
    });
  };
  ns.setup = function() {
    return ns.attachEvents();
  };
  return ns.setup;
});