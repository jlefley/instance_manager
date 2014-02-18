module InstanceManager
  module TestSupport
    module Factory
    
      def create_instance_model attributes = {}
        @inst_seq ||= 0
        @inst_seq += 1
        attributes[:name] ||= "instance#{@inst_seq}"
        instance = Instance.new attributes
        instance.owner = create_private_user email: "owner#{@inst_seq}@123.com"
        instance.save
      end

      def create_instance attributes = {}
        @instance_seq ||= 0
        @instance_seq += 1
        attributes[:name] ||= "instance#{@instance_seq}"
        user = create_private_user
        InstanceManager.create_instance({ name: attributes[:name], owner_attributes: { email: user.email } }, user)
      end

    end
  end
end

if respond_to? :World
  World(InstanceManager::TestSupport::Factory) 
end
