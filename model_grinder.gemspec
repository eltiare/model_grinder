Gem::Specification.new do |s|
  s.name        = 'model_grinder'
  s.version     = '1.0.1'
  s.date        = '2013-01-07'
  s.summary     = "Grind out model data"
  s.description = "An ORM agnostic way to generate models for testing"
  s.authors     = ["Jeremy Nicoll"]
  s.email       = 'jrnicoll@hotmail.com'
  s.files = Dir['lib/**/*.rb']
  s.homepage    =
    'http://rubygems.org/gems/model_grinder'

  s.add_runtime_dependency 'randexp'
end

