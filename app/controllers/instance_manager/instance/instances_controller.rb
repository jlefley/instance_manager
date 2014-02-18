module InstanceManager
  class Instance::InstancesController < ::ApplicationController
    before_filter :authorize_instance_admin!
  
  end
end
