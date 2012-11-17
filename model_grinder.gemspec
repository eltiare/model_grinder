Gem::Specification.new do |s|
  s.name        = 'Model Grinder'
  s.version     = '0.1.0'
  s.date        = '2012-11-17'
  s.summary     = "Grind out model data"
  s.description = "Similar to Datamapper's Sweatshop gem, but for most major ORMs (eventually)"
  s.authors     = ["Jeremy Nicoll"]
  s.email       = 'jrnicoll@hotmail.com'
  s.files = Dir['lib/**/*.rb']
  s.homepage    =
    'http://rubygems.org/gems/model_grinder'

  s.add_runtime_dependency 'randexp'


  # Testing
  s.add_development_dependency 'rspec'

  # DataMapper
  s.add_development_dependency 'dm-core'
  s.add_development_dependency 'dm-sqlite-adapter'
  s.add_development_dependency 'dm-migrations'

  # ActiveRecord
  s.add_development_dependency 'activerecord', '3.2.9'


  # Mongoid
  s.add_development_dependency 'mongo', '1.7.0'
  s.add_development_dependency 'bson', '1.7.0'
  s.add_development_dependency 'bson_ext', '1.7.0'
  s.add_development_dependency "mongoid",  "3.0.11"


end

