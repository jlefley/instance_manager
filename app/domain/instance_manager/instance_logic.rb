module InstanceManager
  module InstanceLogic
  
    def add_admin attributes
      if instance_user = find_instance_user(user: attributes[:user])
        instance_user.admin = true
        instance_user.save
      else
        add_instance_user attributes.merge(admin: true)
      end
    end

  end
end
