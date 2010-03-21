class AddStateToMission < ActiveRecord::Migration
  def self.up
    add_column :missions, :state, :string
  end

  def self.down
    remove_column :missions, :state
  end
end
