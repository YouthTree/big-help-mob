namespace :sync do
  desc "Sanitizes the current local environment"
  task :sanitize => :environment do
    count = 0
    User.find_each do |user|
      user.update_attribute :email, "example-#{count += 1}@example.com"
    end
  end
end