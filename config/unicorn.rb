require 'pathname'
# cd /var/apps/bighelpmob && unicorn_rails -c /var/apps/bighelpmob/config/unicorn.rb -E production -D
 
rails_env  = ENV['RAILS_ENV'] || 'production'
rails_root = Pathname(__FILE__).dirname.dirname
 
working_directory rails_root.to_s
worker_processes  3 # Or however many
 
timeout 30
 
listen rails_root.join("tmp/sockets/unicorn.sock").to_s, :backlog => 256

pid rails_root.join("tmp/pids/unicorn.pid").to_s
 
# Resetup stdout and stderr.
stderr_path rails_root.join("log", "unicorn.stderr.log").to_s
stdout_path rails_root.join("log", "unicorn.stdout.log").to_s
 
# Extra memory savings with passenger.
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true
 
 
before_fork do |server, worker|
  old_pid = rails_root.join("tmp/pids/unicorn.pid.oldbin")
  if File.exists?(old_pid) && server.pid != File.read(old_pid).to_i
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
 
 
after_fork do |server, worker|
  # Reestablish the rails connection
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
  # Start as stuff if running as root.
  worker.user('deploy', 'deploy') if Process.euid == 0
end