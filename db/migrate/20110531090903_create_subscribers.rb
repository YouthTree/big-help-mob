class CreateSubscribers < ActiveRecord::Migration
  def self.up
    create_table :subscribers do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.integer :volunteering_history_id
      t.timestamps
    end
    CollatableOptionSeeder.seed 'subscriber.volunteering_history'
  end

  def self.down
    drop_table :subscribers
    CollatableOptionSeeder.unseed 'subscriber.volunteering_history'
  end
end
