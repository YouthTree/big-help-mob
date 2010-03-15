class RenamePersistenceColumn < ActiveRecord::Migration
  def self.up
    rename_column :users, :persisten_token, :persistence_token
  end

  def self.down
    rename_column :users, :persistence_token, :persisten_token
  end
end
