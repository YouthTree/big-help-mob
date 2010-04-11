class Admin::MissionsController < Admin::BaseController
  
  def dashboard
    @statistics = MissionStatistics.new(resource)
  end
  
  
end
