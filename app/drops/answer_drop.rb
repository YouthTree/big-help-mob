class AnswerDrop < Liquid::Drop
  
  def initialize(question, answer)
    @question, @answer = question, answer
  end
  
end