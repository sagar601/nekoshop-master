ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails/capybara'

require_relative 'test_support/assertions/all'
require_relative 'test_support/cleanup'

# for way less noise when running the tests
ActiveRecord::Base.logger.level = 1

include Warden::Test::Helpers
Warden.test_mode!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
end

module TestHelpers

  def self.dummy_image_file which = 0
    File.new "test/test_support/files/test_image_#{which % 3}.png"
  end
end
