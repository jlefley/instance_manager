module InstanceManager
  module TestSupport
    module URLHelpers

      def instance_url instance
        Capybara.app_host || "http://#{instance.name}.example.com"
      end

      def confirmation_path token
        "/users/confirmation?confirmation_token=#{token}"
      end

      def password_reset_path token
        "/users/password/edit?reset_password_token=#{token}" 
      end

      def confirmation_url instance, token
        instance_url(instance) + confirmation_path(token)
      end

      def password_reset_url instance, token
        instance_url(instance) + password_reset_path(token)
      end

    end
  end
end

if respond_to? :World
  World(InstanceManager::TestSupport::URLHelpers) 
end
