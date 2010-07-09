class Admin::DashboardController < AdminController
  
  def index
    @user_stats                    = UserStatistics.signups_per_day
    @user_ages                     = UserStatistics.count_per_age
    @user_locations                = UserStatistics.user_locations
    @origin_counts, @other_origins = UserStatistics.user_origins
    @site_visits                   = RedisStatTracker.current.visit_stats(14)
  end
  
end
