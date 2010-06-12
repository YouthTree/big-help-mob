class AddFieldsToMission < ActiveRecord::Migration
  def self.up
    add_column :missions, :short_description, :text
  end

  def self.down
    remove_column :missions, :short_description
  end
end
