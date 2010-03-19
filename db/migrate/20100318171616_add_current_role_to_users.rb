class AddCurrentRoleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :current_role_id, :integer
  end

  def self.down
    remove_column :users, :current_role_id
  end
end
