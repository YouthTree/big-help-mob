class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    # Address Indexes
    # add_index :addresses, [:addressable_type]
    # add_index :addresses, [:lat, :lng]
    # add_index :addresses, [:addressable_type, :lat, :lng]
    add_index :addresses, [:addressable_id, :addressable_type, :lat, :lng], :name => "idx_addresses_on_addressable_and_location"
    # Captain applications
    add_index :captain_applications, :user_id
    add_index :contents, :key
    # Mission Participations
    add_index :mission_participations, [:user_id, :mission_id]
    add_index :mission_participations, [:mission_id]
    add_index :mission_participations, [:user_id]
    add_index :mission_participations, [:user_id, :mission_id, :role_id], :name => "idx_mission_participations_on_all_relations"
    add_index :mission_participations, [:mission_id, :role_id]
    add_index :mission_participations, [:user_id, :role_id]
    # mission pickups
    add_index :mission_pickups, [:mission_id, :pickup_id]
    # MQ's
    add_index :mission_questions, [:mission_id]
    add_index :missions, [:user_id]
    add_index :missions, [:organisation_id]
    add_index :missions, [:state]
    # Questions
    add_index :questions, [:visible]
    add_index :questions, [:visible, :position]
    # Roles
    add_index :roles, [:name]
    # User
    add_index :users, [:admin]
    add_index :users, [:login]
    add_index :users, [:persistence_token]
    add_index :users, [:current_role_id]
  end

  def self.down
  end
end
