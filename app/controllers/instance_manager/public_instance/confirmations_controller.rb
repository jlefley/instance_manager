module InstanceManager
  module PublicInstance
    class ConfirmationsController < Devise::ConfirmationsController
      
      def after_resending_confirmation_instructions_path_for resource_name
        main_app.root_path
      end

      def after_confirmation_path_for resource_name, resource
        main_app.root_path
      end

    end
  end
end
