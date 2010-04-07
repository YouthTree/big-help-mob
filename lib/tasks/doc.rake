namespace :doc do
  
  require 'yard'
  require 'yard/rake/yardoc_task'
  
  # Redefine the app task to use YARD.
  YARD::Rake::YardocTask.new(:yard) do |d|
    d.files = Dir["{lib,app}/**/*.rb"]
  end
  
end