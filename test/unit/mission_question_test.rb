require 'test_helper'

class MissionQuestionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Info
#
# Table name: mission_questions
#
#  id               :integer(4)      not null, primary key
#  mission_id       :integer(4)
#  default_value    :string(255)
#  metadata         :text
#  name             :string(255)
#  question_type    :string(255)
#  required_by_role :string(255)
#  viewable_by_role :string(255)     default("all")
#  created_at       :datetime
#  updated_at       :datetime