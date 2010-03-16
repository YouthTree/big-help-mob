module GchartExtensions
  
  def self.extended(klass)
    (class << klass; self; end).register!(:background_fill)
  end
  
  def background_fill=(color)
    @background_fill = color.to_s.gsub(/^\#/, '')
  end
  
  def background_fill
    unless @background_fill.blank?
      "chf=bg,s,#{@background_fill}"
    end
  end
  
end