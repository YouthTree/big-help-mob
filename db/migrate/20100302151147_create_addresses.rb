class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.belongs_to :addressable, :polymorphic => true
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :postcode
      t.string :country
      t.timestamps
    end
    add_index :addresses, [:addressable_id, :addressable_type]
  end

  def self.down
    drop_table :addresses
  end
end
