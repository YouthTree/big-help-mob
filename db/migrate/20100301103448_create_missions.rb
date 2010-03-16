class CreateMissions < ActiveRecord::Migration
  def self.up
    create_table :missions do |t|
      t.string :name, :null => false
      t.text :description, :null => false
      
      # someone obviously created this mission right
      t.integer :user_id
      
      # a mission 'belongs to' an NGO/Organisation
      t.integer :ngo_id
      
      # timing of mission
      t.datetime :occurs_at, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :missions
  end
end
