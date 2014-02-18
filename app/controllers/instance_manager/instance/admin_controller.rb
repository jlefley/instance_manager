module InstanceManager
  class Instance::AdminController < ::ApplicationController
   
    before_filter :authorize_instance_admin!
 
    def index
      @user = User.new
    end

  end
end
