# old task :annotate_models removed

namespace :db do
  desc "Add schema information (as comments) to model files"
  task :annotate do
    require File.join(File.dirname(__FILE__), "../annotate_models.rb")
    AnnotateModels.do_annotations
  end

  desc "Updates database (migrate and annotate models)"
  task :update do
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:annotate'].invoke
    Rake::Task['db:test:prepare'].invoke
  end
  # namespace :migrate do
  #   task :down do
  #     Rake::Task['db:annotate'].invoke
  #     Rake::Task['db:test:prepare'].invoke
  #   end
  #   task :up do
  #     Rake::Task['db:annotate'].invoke
  #     Rake::Task['db:test:prepare'].invoke
  #   end
  #   task :rollback do
  #     Rake::Task['db:annotate'].invoke
  #     Rake::Task['db:test:prepare'].invoke
  #   end
  # end
end
