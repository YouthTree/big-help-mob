BHM.require('Pickups').load(function() {
  BHM.withNS('PickupChooser', function(ns) {
    
    var changingPickup = false;
    
    ns.addressStatusSelector = '#pickup-address';
    ns.addressStatusInner    = 'span';
    ns.pickupChooserSelector = "input[name='mission_participation[pickup_id]']";
    
    var pickups = BHM.Pickups;
    
    ns.getFieldValue = function(e) {
      if(!e) e = $(ns.pickupChooserSelector);
      return Number(e.filter(":checked").val());
    }
    
    ns.setFieldValue = function(value, e) {
      if(!e) e = $(ns.pickupChooserSelector);
      e.removeAttr("checked").filter("[value='" + value + "']").attr("checked", "checked");
    }
    
    ns.setupFieldWatchers = function() {
      // Watch the correct select field.
      var e = $(ns.pickupChooserSelector);
      e.change(function() {
        var id = ns.getFieldValue(e);
        changingPickup = true;
        pickups.selectPickup(id);
        changingPickup = false;
      });
      // Bind the actual pickup select event..
      pickups.onPickupSelect(function(pu) {
        $(ns.addressStatusSelector + ' ' + ns.addressStatusInner).text(pu.title);
        if(!changingPickup) ns.setFieldValue(pu.id);
      });
      // Trigger an initial change callback.
      e.change();
    };
    
    ns.setup = function() {
      $(ns.addressStatusSelector).show();
      ns.setupFieldWatchers();
    }
    
    $(document).ready(ns.setup);    
  });
});