class RoleDrop < DynamicBaseDrop
  
  accessible! :name
  
  def human_name
    role.to_s
  end
  
end