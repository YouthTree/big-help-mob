class Question < ActiveRecord::Base
  
  acts_as_list
  
  validates_presence_of :question, :answer
  
  scope :visible,   where(:visible => true)
  scope :invisible, where(:visible => false)
  scope :ordered,   order('position ASC')
  
  attr_accessible :question, :answer, :visible, :position
  
  def self.update_order(id_array = nil)
    ids = Array(id_array).map { |i| i.to_i }.uniq
    update_all ["position = FIND_IN_SET(id, '?')", ids], ['id IN (?)', ids]
  end
  
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
#  id         :integer(4)      not null, primary key
#  answer     :text
#  position   :integer(4)
#  question   :text
#  visible    :boolean(1)      not null
#  created_at :datetime
#  updated_at :datetime