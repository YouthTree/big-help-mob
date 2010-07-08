var __slice = Array.prototype.slice, __bind = function(func, obj, args) {
    return function() {
      return func.apply(obj || {}, args ? args.concat(__slice.call(arguments, 0)) : arguments);
    };
  };
BHM.withNS('Signup', function(ns) {
  ns.originWrapperSelector = '#user_origin_input';
  ns.replaceField = function replaceField() {
    var container, id, name, select;
    container = $(ns.originWrapperSelector);
    container.removeClass('select').addClass('string');
    select = container.find('select');
    id = select.attr("id");
    name = select.attr("name");
    select.remove();
    return container.find('label').after($('<input />', {
      name: name,
      id: id,
      type: 'text'
    }));
  };
  ns.shouldReplaceField = function shouldReplaceField() {
    return $(("" + ns.originWrapperSelector + " select")).val().toLowerCase() === 'other';
  };
  ns.attachEvents = function attachEvents() {
    return $(("" + ns.originWrapperSelector + " select")).change(__bind(function() {
        if (ns.shouldReplaceField()) {
          return ns.replaceField();
        }
      }, this));
  };
  ns.setup = function setup() {
    return ns.attachEvents();
  };
  return ns.setup;
});