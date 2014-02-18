module InstanceManager
  module TestSupport
    module Authentication

      def sign_in instance, user, password='123456aA'
        visit instance_url(instance) + instance_manager.new_private_user_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: password
        click_button 'Sign in'
      end
      
      def sign_in_admin_interface user, password='123456aA'
        visit 'http://admin.example.com' + instance_manager.new_private_user_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: password
        click_button 'Sign in'
      end    

    end
  end
end

if respond_to? :World
  World(InstanceManager::TestSupport::Authentication)
end
