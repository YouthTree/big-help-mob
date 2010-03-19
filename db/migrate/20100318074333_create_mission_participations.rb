class CreateMissionParticipations < ActiveRecord::Migration
  def self.up
    create_table :mission_participations do |t|
      t.belongs_to :user
      t.belongs_to :mission
      t.string :state
      t.belongs_to :role

      t.timestamps
    end
  end

  def self.down
    drop_table :mission_participations
  end
end
