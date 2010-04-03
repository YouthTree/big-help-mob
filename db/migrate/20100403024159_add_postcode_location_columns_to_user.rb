class AddPostcodeLocationColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :postcode_lat, :decimal, :precision => 15, :scale => 10
    add_column :users, :postcode_lng, :decimal, :precision => 15, :scale => 10
  end

  def self.down
    remove_column :users, :postcode_lat
    remove_column :users, :postcode_lng
  end
end
