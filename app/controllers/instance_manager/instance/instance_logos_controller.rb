module InstanceManager
  class Instance::InstanceLogosController < ::ApplicationController
    
    before_filter :authorize_instance_admin!

    def create
      if params[:instance].blank?
        current_instance.errors.add :logo, 'image file required'
      else
        current_instance.logo = params[:instance][:logo]
        flash.now[:notice] = 'Logo uploaded successfully' if current_instance.save
      end
      render :index
    end

  end
end
