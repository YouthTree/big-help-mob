class Question < ActiveRecord::Base
  include Orderable
  
  orderable_field_is :position
  
  validates_presence_of :question, :answer
  
  scope :visible,   where(:visible => true)
  scope :invisible, where(:visible => false)
  scope :ordered,   order('position ASC')
  
  attr_accessible :question, :answer, :visible, :position
  
  def self.for(page_id)
    visible.ordered.where(:"show_on_#{page_id}" => true)
  end
  
  def answer_as_html
    answer.to_s.html_safe
  end
  
end

# == Schema Info
#
# Table name: questions
#
#  id                       :integer(4)      not null, primary key
#  answer                   :text
#  position                 :integer(4)
#  question                 :text
#  show_on_captain_section  :boolean(1)
#  show_on_mission_page     :boolean(1)
#  show_on_sidekick_section :boolean(1)
#  visible                  :boolean(1)      not null
#  created_at               :datetime
#  updated_at               :datetime