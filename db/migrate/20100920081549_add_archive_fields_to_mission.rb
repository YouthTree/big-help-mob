class AddArchiveFieldsToMission < ActiveRecord::Migration
  def self.up
    add_column :missions, :archived_short_description, :text
    add_column :missions, :archived_description, :text
  end

  def self.down
    remove_column :missions, :archived_description
    remove_column :missions, :archived_short_description
  end
end
