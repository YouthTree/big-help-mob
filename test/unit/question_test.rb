require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Info
#
# Table name: questions
#
#  id         :integer(4)      not null, primary key
#  answer     :text
#  position   :integer(4)
#  question   :text
#  visible    :boolean(1)
#  created_at :datetime
#  updated_at :datetime