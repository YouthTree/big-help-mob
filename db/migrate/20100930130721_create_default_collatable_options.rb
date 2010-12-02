class CreateDefaultCollatableOptions < ActiveRecord::Migration
  
  def self.up
    CollatableOptionSeeder.seed 'user.volunteering_history'
    CollatableOptionSeeder.seed 'user.gender'
  end

  def self.down
    CollatableOptionSeeder.unseed 'user.volunteering_history'
    CollatableOptionSeeder.unseed 'user.gender'
  end
end
