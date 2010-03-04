class ChangeNgoIdToOrganisationIdInMissions < ActiveRecord::Migration
  def self.up
    rename_column :missions, :ngo_id, :organisation_id
  end

  def self.down
  end
end
