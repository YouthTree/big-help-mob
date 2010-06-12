class Content < ActiveRecord::Base

  attr_accessible :content, :key, :title, :type

  validates_presence_of :key

  def self.[](key)
    where(:key => key.to_s).first
  end

  def content_as_html
    content.to_s.html_safe
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
