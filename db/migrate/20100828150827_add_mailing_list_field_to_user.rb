class AddMailingListFieldToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :completed_mailing_list_subscriptions, :boolean, :default => false
    User.update_all :completed_mailing_list_subscriptions => true
  end

  def self.down
    remove_column :users, :completed_mailing_list_subscriptions
  end
end
