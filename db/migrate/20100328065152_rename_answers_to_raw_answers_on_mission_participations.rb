class RenameAnswersToRawAnswersOnMissionParticipations < ActiveRecord::Migration
  def self.up
    rename_column :mission_participations, :answers, :raw_answers
  end

  def self.down
    rename_column :mission_participations, :raw_answers, :answers
  end
end
