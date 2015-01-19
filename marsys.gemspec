Gem::Specification.new do |s|
  s.name        = 'marsys'
  s.version     = '0.0.0'
  s.date        = '2015-01-17'
  s.summary     = "MARSYS for Multi-Agents Ruby System"
  s.description = "MARSYS provides a core to handle simple multi-agents systems"
  s.authors     = ["Lorel"]
  s.email       = 'lorel@wellatribe.com'
  s.files       = [
    "lib/marsys.rb",
    "lib/marsys/agent.rb",
    "lib/marsys/core.rb",
    "lib/marsys/environment.rb",
    "lib/marsys/settings.rb",
    "lib/marsys/config.yml"
  ]
  s.homepage    = 'http://rubygems.org/gems/marsys'
  s.license     = 'CC'
  s.add_runtime_dependency "activesupport", ["= 4.2.0"]
  s.add_runtime_dependency "colorize", ["= 0.7.5"]
end