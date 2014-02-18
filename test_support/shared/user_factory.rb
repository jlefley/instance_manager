module InstanceManager
  module TestSupport
    module Factory

      def create_system_admin
        user = create_private_user
        instance = Instance.new name: 'admin'
        instance.owner = user
        instance.save validate: false
        InstanceUser.create user: user, instance: instance, creator: user, admin: true
        user
      end

      def create_public_admin attributes = {}
        user = build_public_user(attributes)
        user.admin = true
        user.save
      end

      def create_public_user attributes = {}
        build_public_user(attributes).save
      end 

      def build_public_user attributes = {}
        @user_seq ||= 0
        @user_seq += 1
        attributes[:username] ||= "username#{@user_seq}"
        attributes[:email] ||= "test#{@user_seq}@example.com"
        attributes[:password] ||= '123456aA'
        attributes[:password_confirmation] ||= '123456aA'
        
        user = PublicInstance::User.new(attributes)
        user.confirmed_at = Time.now
        user
      end 

      def create_private_user attributes = {}
        build_private_user(attributes).save
      end

      def build_private_user attributes = {}
        @user_seq ||= 0
        @user_seq += 1
        attributes[:email] ||= "email_#{@user_seq}@example.com"
        attributes[:password] ||= '123456aA'
        attributes[:password_confirmation] = attributes[:password]
        
        user = User.new(attributes)
        user.confirmed_at = Time.now
        user
      end

      def create_instance_user instance
        InstanceUser.create user: user = create_private_user, instance: instance, creator: instance.owner
        user
      end

      def create_instance_admin instance
        InstanceUser.create user: user = create_private_user, instance: instance, creator: instance.owner, admin: true
        user
      end

    end
  end
end
