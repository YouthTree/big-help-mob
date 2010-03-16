require 'test_helper'

class NgoTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Info
#
# Table name: organisations
#
#  id          :integer(4)      not null, primary key
#  description :text
#  name        :string(255)
#  permalink   :string(255)
#  telephone   :string(255)
#  website     :string(255)
#  created_at  :datetime
#  updated_at  :datetime