require 'test_helper'

class MissionTest < ActiveSupport::TestCase
  
  should_belong_to :organisation
  should_have_one  :address
  
  should_validate_presence_of :name, :message => 'must be filled in to continue'
  
end

# == Schema Info
#
# Table name: missions
#
#  id                   :integer(4)      not null, primary key
#  organisation_id      :integer(4)
#  user_id              :integer(4)
#  address_title        :string(255)
#  cached_slug          :string(255)
#  captain_signup_open  :boolean(1)      default(TRUE)
#  description          :text            not null, default("")
#  maximum_captain_age  :integer(4)
#  maximum_sidekick_age :integer(4)
#  minimum_captain_age  :integer(4)
#  minimum_sidekick_age :integer(4)
#  name                 :string(255)     not null
#  sidekick_signup_open :boolean(1)      default(TRUE)
#  state                :string(255)
#  created_at           :datetime
#  occurs_at            :datetime        not null
#  updated_at           :datetime