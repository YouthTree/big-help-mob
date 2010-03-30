module MissionsHelper
  
  def join_mission_as_link(mission, role)
    role = role.to_s
    image = "bhm/#{role}-logo.jpg"
    text  = "Join up as a #{role.titleize}"
    inner = image_tag(image, :alt => text)
    url = edit_mission_with_role_path(@mission, :as => role)
    content = ActiveSupport::SafeBuffer.new
    content << link_to(inner, url, :class => "join-as-#{role}", :title => text)
    content << content_section("join-as.#{role}")
    ivar_key = :"@#{role}_questions"
    if instance_variable_defined?(ivar_key)
      questions = instance_variable_get(ivar_key)
      if questions.any?
        content << content_tag(:div, link_to(text, url, :id => "join-as-#{role}-button"), :class => 'join-as-button before-faq')
      end
      content << faq(questions, "FAQ about #{role.to_s.titleize.pluralize}")
    end
    content << content_tag(:div, link_to(text, url, :id => "join-as-#{role}-button"), :class => 'join-as-button')
    content
  end
  
  def join_mission_link(mission)
    return if logged_in? && mission.participating?(current_user)
    inner = link_to('Join this mission', [:join, mission], :class => 'join-mission-link')
    content_tag(:p, inner, :class => 'join-mission-container')
  end
  
end
