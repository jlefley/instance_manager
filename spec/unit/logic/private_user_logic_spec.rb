require 'unit_spec_helper'
require 'private_user_logic'
require 'active_support/hash_with_indifferent_access'

class InstanceManager::Instance; end

describe InstanceManager::PrivateUserLogic do
  let(:user) do
    Class.new { include InstanceManager::PrivateUserLogic; extend InstanceManager::PrivateUserLogic::ClassMethods }
  end
  
  let(:instance) { double 'instance' }
  let(:instance_relationship) { double 'instance user relationship' }
  
  before { @user = user.new }

  describe 'when finding user instance for authentication' do
  
    before do
      user.stub_chain(:devise_parameter_filter, :filter) { |arg| arg }
    end
    
    describe 'when subdomain is not present or is included in ignore list' do
      it 'should return nil' do
        user.find_first_by_auth_conditions(conditions_hash(email: 'user2@test.com')).should == nil
        user.find_first_by_auth_conditions(conditions_hash(email: 'user2@test.com', subdomain: 'www')).should == nil
      end
    end

    describe 'when subdomain is present' do
      describe 'when subdomain is not included in ignore list' do
        describe 'when user matching conditions exists within subdomain' do
          it 'should return user' do
            user.stub(:find_within_instance).with('inst', confirmation_token: 'abc').and_return('user')
            user.find_first_by_auth_conditions(conditions_hash(confirmation_token: 'abc', subdomain: 'inst')).should == 'user'
          end
        end
        describe 'when user matching conditions does not exist within subdomain' do
          it 'should return nil' do
            user.stub(:find_within_instance)
            user.find_first_by_auth_conditions(conditions_hash(email: 'user2@test.com', subdomain: 'inst')).should == nil
          end
        end
      end
    end

  end

  describe 'when determining if user is admin for specified instance' do
    before do
      instance.stub(id: 5)
      @user.stub(:find_instance_relationship).with(5).and_return(instance_relationship)
    end
    describe 'when user is admin for specified instance' do
      it 'should return true' do
        instance_relationship.stub(:admin).and_return(true)
        @user.instance_admin?(instance).should == true
      end
    end
    describe 'when user is not admin for specified instance' do
      it 'should return false' do
        instance_relationship.stub(:admin).and_return(false)
        @user.instance_admin?(instance).should == false
      end
    end
  end
  
  describe 'when determining if user is associated with specified instance' do
    before do
      @user = user.new
      instance.stub(id: 5)
    end
    describe 'when user is associated with specified instance' do
      it 'should return true' do
        @user.stub(:find_instance_relationship).with(5).and_return(instance_relationship)
        
        @user.instance_user?(instance).should == true
      end
    end
    describe 'when user is not associated with specified instance' do
      it 'should return false' do
        @user.stub(:find_instance_relationship)

        @user.instance_user?(instance).should == false
      end
    end
  end

  describe 'when user is not persisted' do
    before do
      @user.stub(persisted?: false)
    end
    describe 'when new associated instance is present (password is set at time of creation)' do #has new associated instance
      it 'should require password' do
        instance.stub(persisted?: false)
        @user.stub(instances: [instance])
        @user.password_required?.should == true
      end
    end
    describe 'when new associated instance is not present (password is not set at time of creation)' do #does not have new associated instance
      it 'should not require password' do
        @user.stub(instances: [])
        @user.password_required?.should == false
      end
    end
  end

  describe 'when user is persisted' do
    before do
      @user.stub(persisted?: true)
    end
    describe 'when encrypted password has been set' do
      before do
        @user.stub(encrypted_password: 'pass')
      end
      describe 'when password or password confirmation are not nil (update password)' do
        it 'should require password' do
          @user.stub(password: 'pass')
          @user.stub(password_confirmation: 'pass')
          @user.password_required?.should == true
        end
      end
      describe 'when password and password confirmation are nil (update other attributes)' do
        it 'should not require password' do
          @user.stub(password: nil)
          @user.stub(password_confirmation: nil)
          @user.password_required?.should == false
        end
      end
    end
    describe 'when encrypted password has not been set (confirming user when password was not set at time of user creation)' do
      it 'should require password' do
        @user.stub(encrypted_password: nil)
        @user.password_required?.should == true
      end
    end
  end

end

def conditions_hash params
  HashWithIndifferentAccess.new params
end

