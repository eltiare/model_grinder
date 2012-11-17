require 'rspec/autorun'
require 'model_grinder'

require "bundler/setup"
require "randexp"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.

Dir[File.join(File.dirname(__FILE__), "/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"
end