module MissionsHelper
  
  def join_mission_as_link(mission, role)
    role               = role.to_s
    image              = "bhm/#{role}-logo.jpg"
    text               = "Join up as a #{role.titleize}"
    inner              = image_tag(image, :alt => text)
    url                = edit_mission_with_role_path(@mission, :as => role)
    signup_closed_text = content_tag(:p, "Signing up as a #{role.humanize} is currently closed.", :class => 'signup-closed')
    signup_open        = @mission.signup_open?(role)
    content = ActiveSupport::SafeBuffer.new
    if signup_open
      content << link_to(inner, url, :class => "join-as-#{role}", :title => text)
    else
      content << content_tag(:div, inner, :class => 'signup-closed-wrapper')
    end
    content << content_section("join-as.#{role}")
    ivar_key = :"@#{role}_questions"
    if instance_variable_defined?(ivar_key)
      questions = instance_variable_get(ivar_key)
      if questions.any?
        if signup_open
          content << content_tag(:div, link_to(text, url, :id => "join-as-#{role}-button"), :class => 'join-as-button before-faq')
        else
          content << signup_closed_text
        end
      end
      content << faq(questions, "FAQ about #{role.to_s.titleize.pluralize}")
    end
    content << (signup_open ? content_tag(:div, link_to(text, url, :id => "join-as-#{role}-button"), :class => 'join-as-button') : signup_closed_text)
    content
  end
  
  def join_mission_link(mission)
    return if mission.is_a?(Mission) && logged_in? && mission.participating?(current_user)
    inner = link_to('Join this mission', join_mission_path(mission), :class => 'join-mission-link')
    content_tag(:p, inner, :class => 'mission-button-container')
  end
  
  def join_or_leave_mission_link(mission)
    if logged_in? && mission.participating?(current_user)
      inner = link_to('Leave this mission', leave_mission_path(mission), :class => 'leave-mission-link', :method => :delete)
    else
      inner = link_to('Join this mission', join_mission_path(mission), :class => 'join-mission-link')
    end
    content_tag(:p, inner, :class => 'mission-button-container')
  end
  

  def render_mission_photos(collection)
    collection.map do |c|
      link_to(image_tag(c.to_url(:s)), c.mission, :title => "View '#{c.mission.name}'")
    end.join.html_safe
  end
  
end
