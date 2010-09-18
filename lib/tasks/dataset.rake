namespace :db do
  namespace :dataset do
    desc "Load one or more datasets into the current environment's database using DATASETS=name,name"
    task :load => :environment do
      require 'dataset'
      dataset_names = (ENV['DATASETS'] || 'default').split(',')
      
      context = Class.new do
        extend Dataset::ContextClassMethods
        datasets_directory [
          Rails.root.join("spec/datasets"),
          Rails.root.join("test/datasets")
        ].detect {|path| path.directory? }.to_s
        add_dataset *dataset_names
        dataset_session.load_datasets_for self
      end
    end
  end
end