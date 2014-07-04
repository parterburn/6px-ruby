Gem::Specification.new do |s|
  s.name        = 'six_px'
  s.version     = '0.0.1'
  s.date        = '2010-04-28'
  s.summary     = "6px API wrapper"
  s.description = "Ruby wrapper for 6px's API"
  s.authors     = ["Nick Quaranto"]
  s.email       = 'mattleonardco@gmail.com'
  s.files       = ["lib/six_px.rb", "lib/six_px/client.rb"]
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'MIT'

  s.add_runtime_dependency 'awesome_print', '>= 1.2.0'
  s.add_runtime_dependency 'httparty', '~> 0.3'
  s.add_runtime_dependency 'json', '~> 1.6'
end