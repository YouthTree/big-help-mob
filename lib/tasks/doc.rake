namespace :doc do
  begin
    require 'yard'
    require 'yard/rake/yardoc_task'
    # Redefine the app task to use YARD.
    YARD::Rake::YardocTask.new(:yard) do |d|
      d.files = Dir["{lib,app}/**/*.rb"]
    end
  rescue LoadError
    puts "rake doc:yard is currently unavailable. Please run in an env with yard"
  end
end