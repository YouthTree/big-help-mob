class Admin::DynamicTemplatesController < Admin::BaseController
  
  belongs_to :mission, :polymorphic => true, :finder => :find_using_slug!
  
end
