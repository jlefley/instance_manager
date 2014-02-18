module InstanceManager
  class Instance::SessionsController < Devise::SessionsController
 
    def destroy
      redirect_path = after_sign_out_path_for(resource_name)
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message :notice, :signed_out if signed_out && is_navigational_format?

      # We actually need to hardcode this as Rails default responder doesn't
      # support returning empty response on GET request
      respond_to do |format|
        format.all { head :no_content }
        format.any(*navigational_formats) { redirect_to redirect_path }
      end
    end

    private

    def after_sign_out_path_for resource_or_scope
      main_app.root_path
      #new_private_user_session_path
    end

  end
end
