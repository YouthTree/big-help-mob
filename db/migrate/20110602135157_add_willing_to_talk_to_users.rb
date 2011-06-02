class AddWillingToTalkToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :willing_to_talk, :boolean
  end

  def self.down
    remove_column :users, :willing_to_talk
  end
end
