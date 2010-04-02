require 'test_helper'

class DynamicTemplateTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Info
#
# Table name: dynamic_templates
#
#  id            :integer(4)      not null, primary key
#  parent_id     :integer(4)
#  content_type  :string(255)
#  key           :string(255)
#  parent_type   :string(255)
#  parts         :text
#  template_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime