class CreateMissionPickups < ActiveRecord::Migration
  def self.up
    create_table :mission_pickups do |t|
      t.belongs_to :mission
      t.belongs_to :pickup

      t.timestamps
    end
  end

  def self.down
    drop_table :mission_pickups
  end
end
