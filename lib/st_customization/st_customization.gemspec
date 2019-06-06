$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "st_customization/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "st_customization"
  s.version     = StCustomization::VERSION
  s.authors     = ["Vladimir Kulakov"]
  s.email       = ["bbcoders.v@gmail.com"]
  s.homepage    = "http://st_customizations.net"
  s.summary     = "An attempt to prvide ShareTribe customizations in a more convenient way"
  s.description = "An attempt to prvide ShareTribe customizations in a more convenient way"
  s.license     = ""

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.6", ">= 5.1.6.2"

  s.add_development_dependency "sqlite3"
end
