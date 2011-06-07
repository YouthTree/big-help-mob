class AddPhotosetIdToMissions < ActiveRecord::Migration
  def self.up
    add_column :missions, :photoset_id, :string
  end

  def self.down
    remove_column :missions, :photoset_id
  end
end
