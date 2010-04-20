class Admin::MissionsController < Admin::BaseController
  include ExtraSluggy::ControllerExt
  
  def dashboard
    @statistics = MissionStatistics.new(resource)
  end
  
  def report
    @mission = resource
    @report = ParticipationReporter.new(resource, self, (params[:report] || {}))
    respond_to do |format|
      format.pdf { send_data @report.render.to_s, :type => :pdf, :disposition => 'inline' }
    end
  end
  
end
