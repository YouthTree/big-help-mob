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
      t.date :date, :null => false
      t.time :time, :null => false
      
      # address fields
      t.string :street1, :null => false
      t.string :street2
      t.string :city, :null => false
      t.string :state
      t.string :zip
      
      # latitude and longitude for mapping    
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10

      t.timestamps
    end
  end

  def self.down
    drop_table :missions
  end
end
