module UuidTrackerHelper
  
  # Returns the current request uuid
  def current_request_uuid
    @current_request_uuid ||= request.env['rack.log-marker.uuid']
  end
  
  # Returns a html comment with the current request uuid
  def uuid_marker_comment
    "<!-- bhm-request-uuid: #{current_request_uuid} -->".html_safe if current_request_uuid.present?
  end
  
end