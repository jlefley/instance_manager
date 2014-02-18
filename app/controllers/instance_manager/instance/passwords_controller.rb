module InstanceManager
  class Instance::PasswordsController < Devise::PasswordsController
 
    def update
      resource_params.merge!(subdomain: request.subdomain)
      super
    end

    def create
      Thread.current[:request_host] = request.host
      resource_params.merge!(subdomain: request.subdomain)
      super
    end

    private

    def root_path
      main_app.root_path
    end
  end
end
