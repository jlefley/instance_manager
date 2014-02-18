module InstanceManager
  class AuthenticationFailure < Devise::FailureApp

    def respond
      # Show flash for private instance
      # Messages are rendered after js redirects on 401 response from xhr request
      flash[:alert] = i18n_message if http_auth? and scope == :private_user
      super
    end

  end
end
