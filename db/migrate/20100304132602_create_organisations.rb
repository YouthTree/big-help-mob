class CreateNgos < ActiveRecord::Migration
  def self.up
    create_table :organisations do |t|
      t.string :name
      t.text :description
      t.string :telephone
      t.string :website
      t.string :permalink

      t.timestamps
    end
  end

  def self.down
    drop_table :ngos
  end
end
