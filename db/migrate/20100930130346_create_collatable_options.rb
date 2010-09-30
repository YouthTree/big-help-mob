class CreateCollatableOptions < ActiveRecord::Migration
  def self.up
    create_table :collatable_options do |t|
      t.string :scope_key
      t.string :name
      t.string :value
      t.timestamps
    end
  end

  def self.down
    drop_table :collatable_options
  end
end
