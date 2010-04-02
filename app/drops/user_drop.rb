class UserDrop < DynamicBaseDrop
                  
  accessible! :login, :email, :display_name, :first_name, :last_name,
              :date_of_birth, :phone, :postcode, :allergies, :captain_application,
              :current_role, :origin, :missions, :mission_participations, :roles
              
  def mailing_address
    user.mailing_address.to_s
  end
  
  def name
    user.to_s
  end
  
end