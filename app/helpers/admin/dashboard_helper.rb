module Admin::DashboardHelper
  
  def user_stats_url
    data = @user_stats
    GoogleChart.Line do |c|
      c.legend    = "User Signups"
      c.axes      = {:x => labels(data.keys.map(&:to_s), 5), :y => (0..(data.values.max))}
      c.data      = data.values
      c.encoding  = :extended
      c.color     = '454545'
      c.size      = '700x200'
    end
  end
  
  protected
  
  def labels(all, count = 3)
    inside_count         = count - 2
    labels               = []
    count                = all.size / (inside_count + 1)
    current = count
    labels << all.first
    while current < (all.size - 1)
      labels << all[current]
      current += count
    end
    labels << all.last
    labels
  end
  
end
