class CaptainApplication < ActiveRecord::Base
end

# == Schema Info
#
# Table name: captain_applications
#
#  id                 :integer(4)      not null, primary key
#  accepted           :boolean(1)
#  has_first_aid_cert :boolean(1)
#  offers             :text
#  reason_why         :text
#  created_at         :datetime
#  updated_at         :datetime