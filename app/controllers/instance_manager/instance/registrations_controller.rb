module InstanceManager
  class Instance::RegistrationsController < Devise::RegistrationsController
    skip_before_filter :require_no_authentication, only: [:create, :new]
    before_filter :authorize_instance_admin!, only: [:create, :new]

    def create
      if self.resource = resource_class.first(email: params[:private_user][:email])
        add_existing_user    
      else
        add_new_user     
      end
    end 

    def update
      Thread.current[:request_host] = request.host
      super
    end

    private

    def add_existing_user
      if add_user_to_instance   
        flash[:success] = "#{resource.email} has been added to this instance"
      else
        flash[:error] = "#{resource.email} is already associated with this instance"
      end
      respond_with resource, :location => after_inactive_sign_up_path_for(resource)
    end

    def add_new_user
      build_resource(sign_up_params)
      Thread.current[:request_host] = request.host

      if resource.save
        add_user_to_instance
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      else
        respond_with resource
      end
    end

    def add_user_to_instance
      InstanceUser.create(user: resource, creator: current_private_user, instance: current_instance)
    end

    def after_inactive_sign_up_path_for resource
      instance_manager.instance_admin_index_path
    end

  end
end

