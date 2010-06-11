class CreateFlickrPhotos < ActiveRecord::Migration
  def self.up
    create_table :flickr_photos do |t|
      t.integer :farm
      t.string :title
      t.string :isprimary
      t.string :flickr_id
      t.string :server
      t.string :secret
      t.belongs_to :mission
      t.timestamps
    end
  end

  def self.down
    drop_table :flickr_photos
  end
end
