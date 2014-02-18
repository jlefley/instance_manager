module InstanceManager
  class System::InstancesController < System::SystemController

    skip_before_filter :authenticate_private_instance_user!, only: :update
    before_filter :authorize_admin!, only: :update

    respond_to :html

    def create
      Thread.current[:request_host] = "#{params[:instance][:name]}.#{request.domain}"
      @instance = InstanceManager.create_instance params[:instance], current_private_user
      flash[:success] = 'Instance created successfully' if @instance.persisted?
      respond_with @instance, location: main_app.system_admin_index_path
    rescue StandardError => e
      flash[:error] = "There was a problem creating the instance: #{e}"
      redirect_to main_app.system_admin_index_path
    end

    def new
      @instance = Instance.new
      @user = User.new
    end
 
    def update
      current_instance.set_fields(params, [:landing_content])
      current_instance.save
      render status: :accepted, json: true
    end

    private

    def instance_params
      params.require(:instance).permit(:landing_content)
    end

  end
end
