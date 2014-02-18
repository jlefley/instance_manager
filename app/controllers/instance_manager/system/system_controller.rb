module InstanceManager
  class System::SystemController < ::ApplicationController
  
    before_filter :authenticate_private_instance_user!

  end
end
