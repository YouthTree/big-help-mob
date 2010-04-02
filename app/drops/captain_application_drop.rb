class CaptainApplicationDrop < DynamicBaseDrop
  
  accessible! :has_first_aid_cert?, :offers, :reason_why
  
  def has_first_aid_cert
    has_first_aid_cert? ? "Yes" : "No"
  end
  
end