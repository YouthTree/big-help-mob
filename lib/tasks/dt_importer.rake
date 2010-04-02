namespace :dt do
  
  desc "Imports default templates"
  task :import => :environment do
    AttrAccessibleScoping.disable do
      Dir[Rails.root.join("data", "dynamic_templates", "*")].each do |t|
        if t.gsub(/^.*\//, '') =~ /^(.+)-(\w+)$/
          key, content_type = $1, $2
          existing = DynamicTemplate.for_content_type(content_type).where(:key => key).first
          existing.destroy if existing
          DynamicTemplate.create!(:key => key, :content => File.read(t), :content_type => content_type)
        end
      end
    end
  end
  
end