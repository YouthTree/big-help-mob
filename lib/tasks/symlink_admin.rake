task :symlink_admin => :environment do
  c = ENV['CONTROLLER']
  if c.blank?
    puts "Please specify a controller with CONTROLLER"
    exit!
  end
  f = Rails.root.join("app", "views", "admin", c)
  FileUtils.mkdir_p(f)
  %w(edit index new show _form).each do |v|
    t = "#{v}.html.haml"
    system "ln -s '../defaults/#{t}' '#{f.join(t).to_s}'"
  end
end