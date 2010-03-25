class AddUserToCaptainApplication < ActiveRecord::Migration
  def self.up
    add_column :captain_applications, :user_id, :integer
  end

  def self.down
    remove_column :captain_applications, :user_id
  end
end
