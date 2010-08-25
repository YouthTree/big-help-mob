class UserStatistics
  
  UserLocation = Struct.new(:postcode, :lat, :lng, :count)

  def self.signups_per_day(from = Date.today - 14, to = Date.today)
    from, to = from.to_date, to.to_date
    users = User.select("DATE(users.created_at) AS users_date, count(*) AS count_all").group("users_date")
    users = users.having(["users_date > ? AND users_date < ?", from - 1, to + 1]).all
    users = users.inject({}) { |a, c| a[c.users_date] = c.count_all.to_i; a }
    results = ActiveSupport::OrderedHash.new
    while from <= to
      results[from] = users[from].to_i
      from += 1
    end
    results
  end
  
  def self.count_per_age
    raw_counts = User.count :all, :group => "DATE_FORMAT(NOW(), '%Y') - DATE_FORMAT(date_of_birth, '%Y') - (DATE_FORMAT(NOW(), '00-%m-%d') < DATE_FORMAT(date_of_birth, '00-%m-%d'))"
    known_ages = raw_counts.keys.map { |k| k.to_i }.reject { |a| a <= 0 } # Cut out invalid dates.
    min, max = known_ages.min, known_ages.max
    ActiveSupport::OrderedHash.new(0).tap do |h|
      min.upto(max) { |c| h[c] = raw_counts[c.to_s].to_i }
    end
  end
  
  def self.user_locations
    scope = User.select("count(*) AS count_in_postcode, postcode, postcode_lat, postcode_lng")
    scope = scope.group("postcode").having("postcode IS NOT NULL AND postcode_lat IS NOT NULL AND postcode_lng IS NOT NULL")
    scope.all.map do |result|
      UserLocation.new("%04d" % result.postcode, result.postcode_lat, result.postcode_lng, result.count_in_postcode.to_i)
    end.sort_by { |r| -r.count }
  end
  
  def self.user_origins
    counts = User.count :all, :group => "origin"
    graph_stats = ActiveSupport::OrderedHash.new(0)
    blank_origins = counts.keys.select { |k| k.blank? }
    graph_stats["Unknown Origin"] = blank_origins.map { |v| counts.delete(v).to_i }.sum
    User::ORIGIN_CHOICES.each do |origin|
      graph_stats[origin] = counts.delete(origin).to_i
    end
    graph_stats["Other"] += counts.map { |k, v| v }.sum
    return graph_stats, counts.sort_by { |l, v| -v }
  end
  
end
