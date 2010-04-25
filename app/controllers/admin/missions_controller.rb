class Admin::MissionsController < Admin::BaseController
  include PseudocephalopodControllerExt
  
  def dashboard
    @statistics     = MissionStatistics.new(resource)
    @user_locations = @statistics.to_user_locations(params[:state_filter], params[:role_filter])
  end
  
  def report
    @mission = resource
    @report = ParticipationReporter.new(resource, (params[:report] || {}))
    respond_to do |format|
      format.csv { send_data @report.to_csv, :type => :csv, :disposition => 'inline' }
    end
  end
  
end
