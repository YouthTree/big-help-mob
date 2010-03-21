module MissionsHelper
  
  def join_mission_as_link(mission, role)
    role = role.to_s
    image = "bhm/#{role}-logo.jpg"
    text  = "Join up as a #{role.titleize}"
    inner = image_tag(image, :alt => text)
    content = content_section("join-as.#{role}")
    url = edit_mission_with_role_path(@mission, :as => role)
    link_to(inner, url, :class => "join-as-#{role}", :title => text) + content
    
  end
  
end
