require 'spec_helper'

describe 'Account confirmation' do

  describe 'when confirming account at subdomain user is not associated with' do
  
    it 'should respond with errors' do
      instance = create_instance
      other_instance = create_instance

      user = create_instance_user instance
      user.confirmed_at = nil
      user.encrypted_password = nil
      user.save

      patch instance_url(other_instance) + instance_manager.private_user_confirm_path,
        private_user: { password: '123456aA', password_confirmation: '123456aA', confirmation_token: user.confirmation_token }

      response.body.downcase.should include 'errors prohibited'
    end

  end

end
