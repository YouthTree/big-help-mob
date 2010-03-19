BHM.require('Pickups').load(function() {
  BHM.withNS('PickupChooser', function(ns) {
    
    var changingPickup = false;
    
    ns.addressStatusSelector = 'span#current-pickup-address'
    ns.pickupChooserSelector = '#mission_participation_pickup_id'
    
    var pickups = BHM.Pickups;
    
    ns.setupFieldWatchers = function() {
      // Watch the correct select field.
      var e = $(ns.pickupChooserSelector);
      e.change(function() {
        var id = Numeric(e.val());
        changingPickup = true;
        pickups.selectPickup(id);
        changingPickup = false;
      });
      // Bind the actual pickup select event..
      pickups.onPickupSelect(function(pu) {
        $(ns.addressStatusSelector).text(pu.title);
        if(!changingPickup) $(ns.pickupChooserSelector).val(pu.id);
      });
      // Trigger an initial change callback.
      e.change();
    };
    
    ns.setup = function() {
      ns.setupFieldWatchers();
    }
    
    $(document).ready(ns.setup);    
  });
});