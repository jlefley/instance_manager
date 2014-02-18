module InstanceManager
  class CreateInstanceService

    attr_reader :user_class, :instance_class, :schema_tools

    def initialize dependencies
      @user_class, @instance_class, @schema_tools = dependencies.values_at :user, :instance, :schema_tools
    end

    def command instance_attributes, current_user
      user = user_class.find email: instance_attributes[:owner_attributes][:email].strip
     
      if user
        instance = instance_class.new name: instance_attributes[:name]
        instance.owner = user
      else
        instance = instance_class.new instance_attributes
      end
      
      if instance.save
        instance.add_admin user: instance.owner, creator: current_user
        schema_tools.create_schema instance.id.to_s
        schema_tools.load_seed instance.id.to_s
      end

      instance
    end

  end
end
