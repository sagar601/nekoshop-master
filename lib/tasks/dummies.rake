namespace :dummies do
  desc "Loads some development dummy data into the database"

  task load: :environment do
    require_relative '../../db/dummy_data'

    DummyData.load
  end

  task reset: ['db:reset', 'dummies:load']
end
