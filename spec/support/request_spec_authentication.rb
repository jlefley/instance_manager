module InstanceManager
  module TestSupport
    module RequestSpecAuthentication
    
      def sign_in_as_instance_user
        instance = create_instance
        user = create_instance_user instance
        @url = instance_url instance
        post @url + instance_manager.private_user_session_path,
          private_user: { email: user.email, password: '123456aA' }, format: :json
        response.status.should == 201
      end

      def sign_in_as_public_instance_user
        user = create_public_user
        post instance_manager.public_user_session_path,
          public_user: { username: user.username, password: '123456aA' }, format: :json
        response.status.should == 201
      end

      def sign_in_as_public_instance_admin
        user = create_public_admin
        post instance_manager.public_user_session_path,
          public_user: { username: user.username, password: '123456aA' }, format: :json
        response.status.should == 201
      end

      def sign_in_as_instance_admin
        instance = create_instance
        user = create_instance_admin instance
        @url = instance_url instance
        post @url + instance_manager.private_user_session_path,
          private_user: { email: user.email, password: '123456aA' }, format: :json
        response.status.should == 201
      end

    end
  end
end
