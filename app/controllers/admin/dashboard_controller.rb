class Admin::DashboardController < AdminController
  
  def index
    @user_stats = User.created_stats_by_day
  end
  
end
