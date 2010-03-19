require 'test_helper'

class MissionPickupTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Info
#
# Table name: mission_pickups
#
#  id         :integer(4)      not null, primary key
#  mission_id :integer(4)
#  pickup_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime