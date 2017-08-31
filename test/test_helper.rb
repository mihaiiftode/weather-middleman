require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

require "minitest/autorun"
require "minitest/around/unit"
require "json_expressions/minitest"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
