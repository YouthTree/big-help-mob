class PieChart
  
  BASE_URL = "http://chart.apis.google.com/chart"
  
  alphabet   = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + %w[- .]
  @@extended = alphabet.map {|a| alphabet.map {|b| a + b }}.flatten
  
  def initialize(data, size = '680x200')
    @size = size
    @data = data.sort_by { |k, v| v }.reverse
  end
  
  def full_labels
    @full_labels ||= @data.map { |k, v| "#{k} (#{v})"}
  end
  
  def labels
    @labels ||= @data.map { |k, v| k }
  end
  
  def values
    @values ||= @data.map { |k, v| v }
  end
  
  def build_params
    parts = Hash.new.tap do |h|
      h[:chs]  = @size.to_s
      h[:chl]  = labels.map { |v| Rack::Utils.escape(v) }.join("|")
      h[:chdl] = full_labels.map { |v| Rack::Utils.escape(v) }.join("|")
      h[:cht]  = "p"
      h[:chd]  = extended_encode([values])
      h[:chf]  = 'bg,s,F9F9F9'
      h[:chco] = '48993C'
    end
    p parts
    qs = []
    parts.each_pair { |k, v| qs << "#{k}=#{v}" }
    qs.join("&")
  end
  
  def to_url
    "#{BASE_URL}?#{build_params}"
  end
  
  def normalize(set, encoding_max)
    min, max = values.min, values.max
    if min != max
      set.map {|e| (e.to_f - min) / (max - min) * encoding_max if e }
    else
      set
    end
  end
  
  def extended_encode(data)
    'e:' + data.map {|set|
      normalize(set, @@extended.size - 1).collect {|e|
        case
        when e.nil? then '__'
        when e <= 0 then @@extended[0]
        when e >= @@extended.size then @@extended[-1]
        else @@extended[e.floor]
        end
      }.join
    }.join(',')
  end
  
end