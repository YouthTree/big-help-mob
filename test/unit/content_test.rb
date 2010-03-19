require 'test_helper'

class ContentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Info
#
# Table name: contents
#
#  id         :integer(4)      not null, primary key
#  content    :text
#  key        :string(255)
#  title      :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime