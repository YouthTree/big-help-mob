class CreateMissionQuestions < ActiveRecord::Migration
  def self.up
    create_table :mission_questions do |t|
      t.belongs_to :mission
      t.string :name
      t.boolean :required
      t.string :question_type
      t.text :metadata

      t.timestamps
    end
  end

  def self.down
    drop_table :mission_questions
  end
end
