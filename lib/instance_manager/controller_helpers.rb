module InstanceManager
  module ControllerHelpers

    private

    def authorize_admin!
      current_scope == :private_user ? authorize_instance_admin! : authorize_public_admin!
    end

    def authorize_instance_admin!
      authenticate_private_user!
      unless current_instance and private_user_signed_in? and current_private_user.instance_admin?(current_instance)
        respond_with_unauthorized
      end
    end

    def authorize_public_admin!
      authenticate_public_user!
      respond_with_unauthorized unless public_user_signed_in? and current_public_user.admin
    end

    def current_instance
      request.env['current_instance']
    end

    def authenticate_private_instance_user!
      if current_scope == :private_user
        sign_in_demo_user if request.subdomain == 'demo'
        authenticate_private_user!
        authorize_private_instance_user if private_user_signed_in?
      end
    end

    def sign_in_demo_user
      return if current_user
      return unless user = User.first(email: 'demo@oneslate.com')
      sign_in(user)
      redirect_to main_app.root_path
    end

    def authenticate_public_instance_user!
      authenticate_public_user! if current_scope == :public_user
    end

    def current_user
      return current_private_user if current_scope == :private_user
      return current_public_user if current_scope == :public_user
    end

    def private_user_root_path
      main_app.root_path
    end

    def public_user_root_path
      main_app.root_path
    end

    def authorize_private_instance_user
      unless current_instance and current_private_user.instance_user?(current_instance)
        flash.discard
        sign_out :private_user
        respond_with_unauthorized
      end
    end

    def respond_with_unauthorized
      respond_to do |format|
        format.json { head :unauthorized }
        format.html { redirect_to main_app.root_path }
      end
    end

    def current_scope
      return :private_user if Constraints::SubdomainRequired.matches? request
      return :public_user if Constraints::PublicDomainRequired.matches? request
    end

    def current_scope_class
      return User if current_scope == :private_user
      return PublicInstance::User if current_scope == :public_user
    end

    def current_user_attributes
      return current_user if current_scope == :public_user
      return current_user.as_json.merge(admin: current_user.instance_admin?(current_instance)) if current_scope == :private_user
    end

  end
end
