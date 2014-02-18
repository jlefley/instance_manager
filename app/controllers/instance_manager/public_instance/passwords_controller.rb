module InstanceManager
  class PublicInstance::PasswordsController < Devise::PasswordsController
    
    private

    def after_sending_reset_password_instructions_path_for(resource_name)
      # Return nil as all requests for password reset instructions are through ajax
    end

  end
end
