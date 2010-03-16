module Admin::DashboardHelper
  
  def user_stats_url
    data = @user_stats
    GoogleChart.Line do |c|
      c.extend GchartExtensions
      c.axes            = {:x => labels(data.keys.map(&:to_s), 5), :y => (0..(data.values.max))}
      c.data            = data.values
      c.encoding        = :extended
      c.color           = '48993C'
      c.background_fill = 'F9F9F9'
      c.size            = '680x200'
    end
  end
  
  protected
  
  def labels(all, count = 3)
    inside_count         = count - 2
    labels               = Array.new(all.size, "")
    count                = all.size / (inside_count + 1)
    current = count
    labels[0] = all.first
    while current < (all.size - 1)
      labels[current] = all[current]
      current += count
    end
    labels[labels.length] = all.last
    labels
  end
  
end
