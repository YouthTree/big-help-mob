BHM.withNS('Admin.NestedForm', function(ns) {
  ns.fieldsetSelector = 'fieldset';
  ns.removeSelector = 'a.remove-link';
  ns.addSelector = 'a.add-link';
  ns.template = '';
  ns.attachEvents = function() {
    $(ns.addSelector).click(function() {
      ns.addItem();
      return false;
    });
    return $(ns.fieldsetSelector).each(function() {
      return ns.attachEventOn($(this));
    });
  };
  ns.attachEventsOn = function(fieldset) {
    return fs.find(ns.removeSelector).click(function() {
      ns.removeItem(this);
      return false;
    });
  };
  ns.addItem = function() {
    var inner;
    inner = ns.template.replace(/NESTED_IDX/g, Numbe(new Date()));
    $("" + ns.fieldsetSelector + ":last").after(inner);
    return ns.attachEventOn($("" + ns.fieldsetSelector + ":last"));
  };
  ns.removeItem = function(link) {
    link = $(link);
    return link.parents(ns.fieldsetSelector).find("input[type=hidden]").val('1').end().hide();
  };
  ns.setup = function() {
    return ns.attachEvents();
  };
  return ns.setup;
});