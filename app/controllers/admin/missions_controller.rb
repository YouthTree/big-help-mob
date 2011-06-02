class Admin::MissionsController < Admin::BaseController
  use_controller_exts :slugged_resource

  def dashboard
    params[:state_filter] ||= "approved"
    @statistics     = MissionStatistics.new(resource)
    @user_locations = @statistics.to_user_locations(params[:state_filter], params[:role_filter])
    # Setup user-specific stats on admins
    @user_statistics               = UserStatistics.new(@statistics.to_user_scope(params[:state_filter], params[:role_filter]))
    @user_stats                    = @user_statistics.signups_per_day
    @user_ages                     = @user_statistics.count_per_age
    @origin_counts, @other_origins = @user_statistics.user_origins
    @user_volunteering_history     = @user_statistics.count_per_volunteering_history
    @user_genders                  = @user_statistics.count_per_gender
  end

  def report
    @mission = resource
    @report = ParticipationReporter.new(resource, (params[:report] || {}))
    respond_to do |format|
      format.csv { send_data @report.to_csv, :type => :csv, :disposition => 'inline' }
    end
  end

end
