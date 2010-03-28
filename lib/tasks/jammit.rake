namespace :jammit do
  
  desc "bundles up assets"
  task :bundle => :environment do
    require 'jammit/command_line'
    old_argv = ARGV.dup
    begin
      ARGV.replace([])
      Jammit::CommandLine.new
    ensure
      ARGV.replace(old_argv)
    end
  end
  
end