require 'test_helper'

class MissionParticipationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Info
#
# Table name: mission_participations
#
#  id         :integer(4)      not null, primary key
#  mission_id :integer(4)
#  pickup_id  :integer(4)
#  role_id    :integer(4)
#  user_id    :integer(4)
#  state      :string(255)
#  created_at :datetime
#  updated_at :datetime