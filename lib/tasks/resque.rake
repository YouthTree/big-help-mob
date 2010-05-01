require 'resque/tasks'

task "resque:setup" => [:environment, "resque:kill_existing", "resque:drop_pid"]

namespace :resque do
  
  task :drop_pid do
    pid = Rails.root.join("tmp", "pids", "resque.pid")
    FileUtils.mkdir_p pid.dirname
    File.open(pid, "w+") do |f|
      f.write Process.pid.to_s
    end
  end
  
  task :kill_existing do
    pid_path = Rails.root.join("tmp", "pids", "resque.pid")
    if pid_path.exist?
      pid = pid_path.read.to_i
      puts "Killing existing process w/ pid #{pid}"
      Process.kill("QUIT", pid) rescue nil if pid > 0
    end
  end
  
end