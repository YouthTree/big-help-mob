class AddCommentToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :comment, :text
    add_column :mission_participations, :comment, :text
  end

  def self.down
    remove_column :users, :comment
    remove_column :mission_participations, :comment
  end
end
