module DatasetExtension

  def self.included(parent)
    parent.class_eval do
      require 'dataset/extensions/rspec2'
      extend Dataset::ContextClassMethods
      datasets_directory Rails.root.join("spec/datasets").to_s
    end
  end

end