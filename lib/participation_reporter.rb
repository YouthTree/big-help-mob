class ParticipationReporter
  
  DEFAULTS = {
    :title => true,
    :role  => true,
    :state => true
  }
  
  cattr_accessor :bin_path
  @@bin_path ||= "/usr/local/bin/prince"
  
  attr_reader :mission, :collection
  
  def self.default_for(key)
    !!DEFAULTS[key.to_sym]
  end

  def initialize(mission, controller, options = {})
    @mission    = mission
    @collection = mission.mission_participations.all(:include => {:role => nil, :user => nil, :pickup => {:pickup => :address}})
    @controller = controller
    @options    = (options.is_a?(Hash) ? options : {}).symbolize_keys
  end
  
  def show?(key)
    key = key.to_sym
    if @options.has_key?(key)
      ActiveRecord::ConnectionAdapters::Column.value_to_boolean(@options[key])
    else
      !!DEFAULTS[key.to_sym]
    end
  end
  
  def render
    template = @controller.render_to_string({
      :template => "pdfs/participation_report",
      :layout   => "report",
      :locals   => {
        :reporter   => self,
        :collection => @collection
      },
    })
    html2prince clean_html(template), render_options
  end
  
  def render_options
    {}
  end
  
  protected
  
  def html2prince(html, options = {})
    command = [@@bin_path.dup]
    command << "--input=html --server --log='#{Rails.root.join("log", "prince.log")}'"
    Array(options[:stylesheets]).each do |stylesheet|
      command << "-s '#{stylesheet_path stylesheet}'"
    end
    command << "--silent - -o -"
    Rails.logger.debug "Prince Command: #{command.join(" ").inspect}"
    pdf = IO.popen(command.join(" "), "w+")
    pdf.puts(html)
    pdf.close_write
    result = pdf.gets(nil)
    pdf.close_read
    result
  end
  
  # Using code from Princely.
  def clean_html(html_string)
    html_string = html_string.dup
    html_string.gsub!( /src=["']+([^:]+?)["']/i ) { |m| "src=\"#{Rails.root}/public/" + $1 + '"' } # re-route absolute paths
    html_string.gsub!( /src=["'](\S+\?\d*)["']/i ) { |m| 'src="' + $1.split('?').first + '"' }
    html_string
  end
  
  # Using code from Princely
  def stylesheet_path(stylesheet)
    stylesheet = stylesheet.to_s.gsub(".css","") + ".css"
    Rails.root.join("public", "stylesheets", stylesheet)
  end
  
end