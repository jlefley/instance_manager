module InstanceManager
  class Engine < ::Rails::Engine
    isolate_namespace InstanceManager
    
    config.generators do |g|
      g.test_framework false
      g.view_specs false
      g.helper_specs false
      g.assets false
      g.helper false
    end

    # Include custom helpers into application controller
    ActiveSupport.on_load(:action_controller) do
      include ControllerHelpers
      helper_method :current_user
      helper_method :current_scope
      helper_method :current_user_attributes
      helper_method :current_instance
    end

    rake_tasks do
      load 'instance_manager/railties/generate_usernames.rake'
      load 'instance_manager/railties/public_schema.rake'
    end

    config.autoload_once_paths += %W(#{root}/app/middleware)

    initializer 'instance_manager.add_middleware' do |app|
      app.middleware.use 'InstanceManager::SchemaSelector', OSTools::Schema
    end
  end
end
