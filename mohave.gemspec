$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mohave/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mohave"
  s.version     = Mohave::VERSION
  s.authors     = ["Evgeny Grep"]
  s.email       = ["gyorms@gmail.com"]
  s.homepage    = ""
  s.summary     = "Rails dashboards' generators."
  s.description = "Rails dashboards' generators."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"

  s.add_development_dependency "sqlite3"
end
