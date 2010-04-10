require 'net/http'

namespace :deploy do
  
  def deploy_config(key = :nothing)
    (@deploy_config ||= YAML.load_file("config/deploy.yml").symbolize_keys)[key.to_sym]
  end
  
  def deploy_path
    deploy_config(:app).to_s
  end
  
  def disable_staging!
    deploy_config
    @deploy_config[:app] = deploy_path.gsub(/\-staging/, '')
  end
  
  def enable_staging!
    deploy_config
    # Remove and readd the suffix.
    @deploy_config[:app] = "#{deploy_path.gsub(/\-staging/, '')}-staging"
  end
  
  def staging?
    deploy_path =~ /\-staging/
  end
  
  def execute_remote_command!(c)
    command = "ssh -A #{deploy_config(:user)}@#{deploy_config(:host)} '#{c.gsub("'", "\\'")}'"
    puts "[REMOTE]> #{command}"
    system command
  end
  
  def execute_local_command!(c)
    puts "[LOCAL]> #{c}"
    system c
  end
  
  def bundle_exec!(c)
    execute_local_command!("bundle exec #{c}")
  end
  
  def get_error_page!(code, name)
    puts "URL: #{"http://#{staging? ? "staging." : ""}bighelpmob.org/errors/#{name}"}"
    new_page = Net::HTTP.get(URI.parse("http://#{staging? ? "staging." : ""}bighelpmob.org/errors/#{name}"))
    new_page.gsub!(/<!-- bhm-request-uuid: \S+ -->/, '')
    File.open("public/#{code}.html", "w+") { |f| f.write new_page }
  rescue => e
    puts "There was an error getting #{code}: #{name} (#{e.class.name}: #{e.message})"
    nil
  end
  
  # Hooks as needed
  
  task :remote_before do
    execute_local_command! "rm -rf config/database.yml"
    execute_local_command! "ln -s database.yml.real config/database.yml"
    bundle_exec!           "compass -u ."
    bundle_exec!           "jammit"
    execute_local_command! "rake db:migrate" if ENV['MIGRATE_ENV'] == "true"
  end
  
  task :remote_after do
    execute_local_command! "mkdir -p tmp"
    if File.exist?("tmp/pids/unicorn.pid")
      begin
        pid = File.read("tmp/pids/unicorn.pid").to_i
        Process.kill(:USR2, pid)
      rescue Errno::ENOENT, Errno::ESRCH
      end
      puts "[LOCAL] Found pid, attempted to restart."
    else
      puts "[LOCAL] Couldn't find a pid."
    end
    sleep 10
    puts "Getting error pages..."
    get_error_page! 500, "internal-server-error"
    get_error_page! 404, "not-found"
    puts "Error pages updated."
  end
  
  task :local_before do
  end
  
  task :local_after do
  end
  
  # Actual deploy
  
  desc "Runs a debug w/ from and to"
  task :debug do
    from, to = ENV['FROM'], ENV['TO']
    if from.blank? || to.blank?
      puts "Please provide from and to"
      exit!
    end
    env_command  = "export PATH=\"/opt/ruby-ee/current/bin:$PATH\""
    rake_env     = "RAILS_ENV=#{ENV['RAILS_ENV'] || 'production'} FROM=#{from} TO=#{to}"
    rake_command = "bundle exec rake debug:between"
    execute_remote_command! "cd #{deploy_config(:app)} && #{env_command} && #{rake_command} #{rake_env}"
  end
  
  task :staging do
    puts "Changing to use staging"
    enable_staging!
  end
  
  task :production do
    puts "Changing to use production"
    disable_staging!
  end
  
  desc "Runs a local deploy"
  task :remote do
    # Do all setup etc
    Rake::Task["deploy:remote_before"].invoke
    # Restart the application.
    Rake::Task["deploy:remote_after"].invoke
  end
  
  desc "Runs a remote deploy"
  task :local do
    Rake::Task["deploy:local_before"].invoke
    puts "Deploying app to #{staging? ? "staging" : "production"}"
    git_command     = "git reset --hard HEAD && git checkout . && git pull"
    env_command     = "export PATH=\"/opt/ruby-ee/current/bin:$PATH\""
    bundler_command = "bundle install .bundle-cache"
    rake_command    = "bundle exec rake deploy:remote"
    rake_command << " MIGRATE_ENV=true" if %w(true 1).include?(ENV['MIGRATE_ENV'].to_s.downcase)
    rake_command << " RAILS_ENV=#{ENV['RAILS_ENV'] || "production"}"
    execute_remote_command! "cd #{deploy_config(:app)} && #{env_command} && #{git_command} && #{bundler_command} && #{rake_command}"
    Rake::Task["deploy:local_after"].invoke
  end
  
  desc "Sets up the remote with an initial clone"
  task :setup do
    git_repo = `git config remote.origin.url`.strip
    execute_remote_command! "mkdir -p #{deploy_config(:app)} && cd #{deploy_config(:app)} && git clone #{git_repo} ."
    puts "[LOCAL] Please login and generate database.yml etc."
  end
  
end

task :deploy     => "deploy:local"
task :staging    => "deploy:staging"
task :production => "deploy:production"