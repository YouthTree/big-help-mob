module Admin::PickupsHelper
  
  def link_to_pickup(pickup)
    opts = {:title => pickup.address.to_s, :class => "pickup-entry"}
    opts["data-pickup-title"]     = "#{pickup.name} - #{pickup.address}"
    opts["data-pickup-latitude"]  = pickup.address.lat
    opts["data-pickup-longitude"] = pickup.address.lng
    opts["data-pickup-id"]        = pickup.id
    link_to pickup.name, [:admin, pickup], opts
  end
  
end
