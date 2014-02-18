module InstanceManager
  class Instance::ConfirmationsController < Devise::ConfirmationsController
   
    # Inspiration for modifications: https://github.com/plataformatec/devise/wiki/How-To:-Email-only-sign-up 

    skip_before_filter :authenticate_private_instance_user!

    def show
      confirmation_token = params[:confirmation_token]
      self.resource = resource_class.find_by_confirmation_token_and_subdomain confirmation_token, request.subdomain
      
      if resource.persisted?
        if resource.encrypted_password.nil?
          render
        else
          InstanceManager.complete_instance_creation(resource, current_instance)
          confirm_resource(confirmation_token)
        end
      else
        respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
      end
    end

    def confirm
      confirmation_token = confirm_params.delete(:confirmation_token)
      self.resource = resource_class.find_by_confirmation_token_and_subdomain confirmation_token, request.subdomain
      
      if resource.persisted? and resource.update_attributes(confirm_params)  
        confirm_resource(confirmation_token)
      else
        clean_up_passwords resource
        respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :show }
      end
    end

    def create
      Thread.current[:request_host] = request.host
      resource_params.merge!(subdomain: request.subdomain)
      super
    end

    private

    def confirm_resource confirmation_token
      sign_out if signed_in? and !resource.confirmed?
      resource.confirm_by_token!(confirmation_token)
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    end

    def confirm_params
      @confirm_params ||= params.require(resource_name).permit(:confirmation_token, :password, :password_confirmation) 
    end

    def after_confirmation_path_for(resource_name, resource)
      if signed_in?
        main_app.root_path
      else
        new_private_user_session_path
      end
    end

  end
end
