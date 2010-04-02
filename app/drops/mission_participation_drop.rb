class MissionParticipationDrop < DynamicBaseDrop
  
  accessible! :mission, :user, :role, :pickup, :approved?, :created?, :awaiting_approval?
  
  def answers
    values = []
    answers = mission_participation.answers
    mission_participation.answers.each_question do |q, key|
      values << AnswerDrop.new(q.name, answers.try(key))
    end
    values
  end
  
end