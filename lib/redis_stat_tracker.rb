class RedisStatTracker

  cattr_accessor :current

  def initialize(app, opts = {})
    @app         = app
    @period      = opts.fetch(:period, 12.hours).to_i
    @namespace   = opts.fetch(:namespace, "redis-stat-tracker")
    @redis       = opts.fetch(:redis, Redis.new) rescue nil
    self.current = self
  end

  def call(env)
    res = @app.call(env)
    # Increase the number of hits for the current key.
    begin
      @redis.incr current_stat_key if @redis
    rescue
    end
    res
  end

  def current_stat_key
    key_for_time(Time.now)[1]
  end

  def key_for_time(time)
    current_period = (time.to_i / @period).round * @period
    return Time.at(current_period), "#{@namespace}:visits:#{current_period}"
  end

  def visit_stats(n)
    times, keys = [], []
    (14 - 1).to_i.downto(0) do |i|
      time, key = key_for_time(Time.now - (i * @period))
      times << time
      keys  << key
    end
    counts = ActiveSupport::OrderedHash.new
    values = (@redis ? @redis.mget(*keys) : []) rescue []
    times.each_with_index { |time, idx| counts[time] = values[idx].to_i }
    counts
  end

  protected

  def bot?(env)
    env["HTTP_USER_AGENT"].to_s =~ /(crawl|bot|slurp|spider)/i
  end

end
