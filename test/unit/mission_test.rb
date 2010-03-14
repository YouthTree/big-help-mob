require 'test_helper'

class MissionTest < ActiveSupport::TestCase
  
  should_belong_to :organisation
  should_have_one  :address
  
  should_validate_presence_of :name
  
end


# == Schema Info
#
# Table name: missions
#
#  id              :integer(4)      not null, primary key
#  organisation_id :integer(4)
#  user_id         :integer(4)
#  city            :string(255)     not null
#  date            :date            not null
#  description     :text            not null, default("")
#  lat             :decimal(15, 10)
#  lng             :decimal(15, 10)
#  name            :string(255)     not null
#  state           :string(255)
#  street1         :string(255)     not null
#  street2         :string(255)
#  time            :time            not null
#  zip             :string(255)
#  created_at      :datetime
#  updated_at      :datetime