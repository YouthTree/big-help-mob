module Dataset
  module Extensions # :nodoc:
    module RSpec # :nodoc:
      def dataset(*datasets, &block)
        add_dataset(*datasets, &block)
        
        load = nil
        before(:all) do
          load = dataset_session.load_datasets_for(self.class)
          extend_from_dataset_load(load)
        end
        before(:each) do
          extend_from_dataset_load(load)
        end
      end
    end
    
  end
end

RSpec.configure do |config|
  config.extend Dataset::ContextClassMethods
  config.extend Dataset::Extensions::RSpec
  config.add_setting :datasets_directory, :default => Rails.root + 'spec/datasets'
  config.add_setting :datasets_dump_path, :default => Rails.root + 'tmp/dataset'
end

Dataset::Resolver.default = nil
