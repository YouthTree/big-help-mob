class AddGeocodingColumnsToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :lat, :decimal, :precision => 15, :scale => 10
    add_column :addresses, :lng, :decimal, :precision => 15, :scale => 10
  end

  def self.down
    remove_column :addresses, :lng
    remove_column :addresses, :lat
  end
end
