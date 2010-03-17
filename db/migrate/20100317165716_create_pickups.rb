class CreatePickups < ActiveRecord::Migration
  def self.up
    create_table :pickups do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :pickups
  end
end
