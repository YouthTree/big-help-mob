class AddDefaultValueToQuestion < ActiveRecord::Migration
  def self.up
    add_column :mission_questions, :default_value, :string
  end

  def self.down
    remove_column :mission_questions, :default_value
  end
end
