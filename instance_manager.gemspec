$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "instance_manager/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "instance_manager"
  s.version     = InstanceManager::VERSION
  s.authors     = ['Jason Lefley']
  s.email       = ['jason@oneslate.com']
  s.homepage    = 'http://oneslate.com'
  s.summary     = 'Provides functionality to handle global authentication and data scoping for Oneslate instances'
  s.description = 'Top level instance and user management for Oneslate application'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'rails', '~> 4.0.0'
  s.add_dependency 'sequel'
  s.add_dependency 'sequel_pg'
  s.add_dependency 'sequel-rails'
  s.add_dependency 'os_tools'
  s.add_dependency 'devise'
  s.add_dependency 'orm_adapter-sequel'
  s.add_dependency 'devise_sequel'
  s.add_dependency 'dynamic_form'
  s.add_dependency 'carrierwave'
  s.add_dependency 'carrierwave-sequel'

  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
end
