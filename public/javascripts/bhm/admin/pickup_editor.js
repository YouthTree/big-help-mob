BHM.withNS('Admin.PickupEditor', function(ns) {
  
  ns.fieldsetSelector   = '.pickup-input';
  ns.individualSelector = 'select';
  ns.removeSelector     = 'a.remove-pickup-link';
  ns.addSelector        = 'a.add-pickup-link';
  ns.template           = '';
  
  ns.attachEvents = function() {
    $(ns.addSelector).click(function() {
      ns.addPickup();
      return false;
    })
    $(ns.fieldsetSelector).each(function() { ns.attachEventOn($(this)); });
  };
  
  ns.attachEventOn = function(fs) {
    fs.find(ns.removeSelector).click(function() {
      ns.deletePickup(this);
      return false;
    })
  };
  
  ns.addPickup = function() {
    var inner = ns.template.replace(/QUESTION_IDX/g, Number(new Date()));
    $(ns.fieldsetSelector + ":last").after(inner);
    ns.attachEventOn($(ns.fieldsetSelector + ":last"));
  }
  
  ns.deletePickup = function(link) {
    var link = $(link);
    link.parents(ns.fieldsetSelector).find('input[type=hidden]').val('1').end().hide();
  };
  
  ns.setup = function() {
    ns.attachEvents();
  };
  
});