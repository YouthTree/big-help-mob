namespace :debug do
  
  desc "Returns items between and FROM until TO"
  task :between do
    from, to = ENV['FROM'], ENV['TO']
    if from.to_s.strip.empty?
      puts "Please provide from"
      exit
    elsif to.to_s.strip.empty?
      puts "Please provide to"
      exit
    end
    from_regexp = /Before request with UUID: #{Regexp.escape(from)}/
    to_regexp = /After request with UUID: #{Regexp.escape(to)}/
    started, ended = false, false
    rails_env = ENV['RAILS_ENV'] || 'production'
    File.open("log/#{rails_env}.log") do |f|
      until ended || f.eof?
        line = f.readline.to_s.strip
        started ||= !(line !~ from_regexp)
        ended   ||= !(line !~ to_regexp)
        puts line if started
      end
    end
  end
  
end