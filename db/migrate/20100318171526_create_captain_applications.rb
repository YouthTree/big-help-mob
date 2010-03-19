class CreateCaptainApplications < ActiveRecord::Migration
  def self.up
    create_table :captain_applications do |t|
      t.text :reason_why
      t.text :offers
      t.boolean :has_first_aid_cert
      t.boolean :accepted

      t.timestamps
    end
  end

  def self.down
    drop_table :captain_applications
  end
end
