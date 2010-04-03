class AddCachedSlugToMission < ActiveRecord::Migration
  def self.up
    add_column :missions, :cached_slug, :string
    add_index :missions, :cached_slug
  end

  def self.down
    remove_column :missions, :cached_slug
  end
end
