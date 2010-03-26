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
#  id            :integer(4)      not null, primary key
#  mission_id    :integer(4)
#  metadata      :text
#  name          :string(255)
#  question_type :string(255)
#  required      :boolean(1)
#  created_at    :datetime
#  updated_at    :datetime