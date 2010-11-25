class Admin::UsersController < Admin::BaseController
  use_controller_exts :slugged_resource
end
