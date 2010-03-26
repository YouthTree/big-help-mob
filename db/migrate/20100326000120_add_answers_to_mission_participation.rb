class AddAnswersToMissionParticipation < ActiveRecord::Migration
  def self.up
    add_column :mission_participations, :answers, :text
  end

  def self.down
    remove_column :mission_participations, :answers
  end
end
