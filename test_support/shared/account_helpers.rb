module InstanceManager
  module TestSupport
    module AccountHelpers
      
      def request_confirmation_link instance, email
        ActionMailer::Base.deliveries.clear 
        click_link 'Sign out'
        visit instance_url(instance) + instance_manager.new_private_user_confirmation_path
        fill_in 'Email', with: email
        click_button 'Resend confirmation instructions'
      end

      def visit_confirmation_link instance, user
        user.send_confirmation_instructions
        visit confirmation_url(instance, user.raw_confirmation_token)
      end

      def request_password_reset instance, user
        visit instance_url(instance) + instance_manager.new_private_user_password_path
        fill_in 'Email', with: user.email
        click_button 'Send me reset password instructions'
        page.should have_content /you will receive a password recovery link/i
      end

      def change_password instance, token, new_password
        visit password_reset_url(instance, token)
        fill_in 'New password', with: new_password
        fill_in 'Confirm new password', with: new_password
        click_button 'Change my password'
      end

      def find_private_user conditions
        User.first conditions
      end

    end
  end
end

if respond_to? :World
  World(InstanceManager::TestSupport::AccountHelpers)
end
