module InstanceManager
  module PublicInstance
    class RegistrationsController < Devise::RegistrationsController
      
      private
      
      def account_update_params
        params.require(:public_user).permit(:email, :password, :password_confirmation, :current_password)
      end

      def sign_up_params
        params.require(:public_user).permit(:username, :email, :password, :password_confirmation)
      end

      def after_inactive_sign_up_path_for resource
        main_app.confirm_path
      end

      def after_update_path_for resource
        main_app.confirm_path
      end

    end
  end
end
