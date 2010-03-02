class CreateRpxIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :rpx_identifiers do |t|
      t.string   :identifier,    :null => false
      t.string   :provider_name
      t.integer  :user_id,       :null => false
      t.timestamps
    end

    add_index :rpx_identifiers, [:identifier], :name => "index_rpx_identifiers_on_identifier", :unique => true
    add_index :rpx_identifiers, [:user_id],    :name => "index_rpx_identifiers_on_user_id"

  end

  def self.down
    drop_table :rpx_identifiers
  end
end
