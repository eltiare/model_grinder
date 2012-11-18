require "bundler/setup"
require "randexp"
require "dm-core"
require "active_record"
require "mongoid"
require 'rspec/autorun'
require 'model_grinder'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.

Dir[File.join(File.dirname(__FILE__), "/support/**/*.rb")].each {|f| require f}

DataMapper.finalize

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"
end