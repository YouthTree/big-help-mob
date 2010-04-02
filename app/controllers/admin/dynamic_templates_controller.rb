class Admin::DynamicTemplatesController < Admin::BaseController
  
  belongs_to :mission, :polymorphic => true
  
end
