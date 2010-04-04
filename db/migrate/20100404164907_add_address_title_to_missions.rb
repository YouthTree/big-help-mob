class AddAddressTitleToMissions < ActiveRecord::Migration
  def self.up
    add_column :missions, :address_title, :string
  end

  def self.down
    remove_column :missions, :address_title
  end
end
