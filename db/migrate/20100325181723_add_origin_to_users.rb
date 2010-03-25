class AddOriginToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :origin, :string
  end

  def self.down
    remove_column :users, :origin
  end
end
