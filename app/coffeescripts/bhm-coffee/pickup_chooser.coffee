BHM.require 'Pickups', ->
  BHM.withNS 'PickupChooser', (ns) ->
    
    changingPickup: false
    pickups:        BHM.Pickups
    
    ns.addressStatusSelector: "#pickup-address"
    ns.addressStatusInner:    "span"
    ns.pickupChooserSelector: "input[name='mission_participation[pickup_id]']"
    
    ns.fieldValue: (element, value) ->
      element: $ ns.pickupChooserSelector unless element?
      if value?
        element.removeAttr("checked").filter("[value='$value']").attr "checked", "checked"
      else
        Number element.filter(":checked").val()
        
    ns.setupFieldWatchers: ->
      element: $ ns.pickupChooserSelector
      element.change ->
        id: ns.fieldValue element
        changingPickup: true
        pickups.selectPickup id, true
        changingPickup: false
      pickups.onPickupSelect (pu) ->
        $("$ns.addressStatusSelector $ns.addressStatusInner").text pu.title
        ns.fieldValue element, pu.id
      element.change()
    
    ns.setup: ->
      $(ns.addressStatusSelector).show()
      ns.setupFieldWatchers()