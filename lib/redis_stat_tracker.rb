class RedisStatTracker

  STAT_TRACKER_KEY = "redis-stat-tracker.enable".freeze

  cattr_accessor :current

  def initialize(app, opts = {})
    @app         = app
    @period      = opts.fetch(:period, 1.minute).to_i
    @namespace   = opts.fetch(:namespace, "redis-stat-tracker")
    @redis       = opts.fetch(:redis, Redis.new)
    self.current = self
  end

  def call(env)
    env[STAT_TRACKER_KEY] = true
    @app.call(env)
    # Increase the number of hits for the current key.
    if env[STAT_TRACKER_KEY] && !bot?(env)
      @redis.incr current_stat_key
    end
  end

  def current_stat_key
    key_for_time Time.now
  end

  def key_for_time(time)
    current_period = (time.to_i / @period).round * period
    "#{@namespace}:visits:#{current_period}"
  end

  def keys_between(period_start = (@period * 14).ago, period_end = Time.now)
    keys  = []
    times = []
    counts = ActiveSupport::OrderedHash.new
    time  = period_start
    while time <= period_end
      keys << key_for_time(time)
      time += @period
    end
    @redis.mget(*keys).each_with_index do |v, i|
      counts[times[i]] = v.to_i
    end
  end

  protected

  def bot?(env)
    env["HTTP_USER_AGENT"].to_s =~ /(crawl|bot|slurp|spider)/i
  end

end
