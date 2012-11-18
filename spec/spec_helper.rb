require "bundler/setup"
require "randexp"
require "dm-core"
require "dm-migrations"
require "active_record"
require "active_record/migration"
require 'sqlite3/sqlite3_native'
require 'sqlite3'
require 'mongo'
require 'bson'
require "mongoid"
require 'rspec/autorun'
require 'model_grinder'

# ActiveRecord setup
# must be done before setting schema
ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: ":memory:"
)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
support_dir = File.join(File.dirname(__FILE__), "support")
Dir[File.join(support_dir, "/**/*.rb")].each {|f| require f}


# DataMapper setup
DataMapper.finalize
DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.auto_migrate!

# Mongoid setup
Mongoid.configure do |c|
  c.sessions = { default: { database: 'model_grinder_test', hosts: ['localhost:27017'] }}
end



RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"
end