module InstanceManager
  module TestSupport
    module EmailHelpers

      def assert_password_recovery_email instance, user
        last_delivery.to.should include user.email
        token = user.send_reset_password_instructions
        last_delivery.body.parts[0].body.should include password_reset_url(instance, token)
        last_delivery.body.parts[1].body.should include password_reset_url(instance, token)
      end

      def assert_confirmation_email instance, user
        last_delivery.to.should include user.email
        user.send_confirmation_instructions
        last_delivery.body.parts[0].body.should include confirmation_url(@instance, user.raw_confirmation_token)
        last_delivery.body.parts[1].body.should include confirmation_url(@instance, user.raw_confirmation_token)
      end

      def last_delivery
        ActionMailer::Base.deliveries.last
      end

    end
  end
end

if respond_to? :World
  World(InstanceManager::TestSupport::EmailHelpers) 
end
