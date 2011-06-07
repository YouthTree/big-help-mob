class AddGenderDetails < ActiveRecord::Migration
  def self.up
    add_column :users, :gender_id, :integer
    CollatableOptionSeeder.seed 'user.gender'
  end

  def self.down
    remove_column :users, :gender_id
    CollatableOptionSeeder.unseed 'user.gender'
  end
end
