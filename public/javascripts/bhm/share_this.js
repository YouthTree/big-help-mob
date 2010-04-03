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
     url:   ns.getURL()
   });
  };
  
  ns.attachEvents = function() {
    var entry = ns.getEntry();
    $(ns.shareThisSelector).show().click(function() { return false; }).each(function() {
      var destination = $(this).attr("data-share-this-target");
      if(destination)
        entry.attachChicklet(destination, this);
      else
        entry.attachButton(this);
    });
  };
  
  ns.setup = ns.attachEvents;
  
});