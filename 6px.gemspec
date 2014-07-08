Gem::Specification.new do |s|
  s.name        = '6px'
  s.version     = '0.0.1'
  s.date        = '2010-04-28'
  s.summary     = "6px API wrapper"
  s.description = "Ruby wrapper for 6px's API"
  s.authors     = ["Nick Quaranto"]
  s.email       = 'mattleonardco@gmail.com'
  s.files       = ["lib/6px.rb", "lib/6px/client.rb"]
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'MIT'

  s.add_runtime_dependency 'httparty', '~> 0.3'
  s.add_runtime_dependency 'json', '~> 1.6'
end