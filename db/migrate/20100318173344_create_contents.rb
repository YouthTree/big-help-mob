class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.string :title
      t.string :key
      t.string :type
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
