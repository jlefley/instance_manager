require 'unit_spec_helper'
require 'instance_logic'

describe InstanceManager::InstanceLogic do

  let(:instance) { Class.new { include InstanceManager::InstanceLogic } }

  before do
    @instance = instance.new
  end

  let(:instance_user) { double 'instance user' }

  describe 'when adding admin' do
  
    describe 'when specified user is already associated as a user' do
      before do
        @instance.stub(:find_instance_user).with(user: 'user').and_return(instance_user)
      end

      it 'should set the instance user flag to true' do
        instance_user.stub(:save)
        instance_user.should_receive(:admin=).with(true)
        @instance.add_admin user: 'user', creator: 'user'
      end

      it 'should save the instance user' do
        instance_user.stub(:admin=)
        instance_user.should_receive(:save)
        @instance.add_admin user: 'user', creator: 'user'
      end
    end

    describe 'when specified user is not already associated as a user' do
      it 'should add an instance user with the admin flag set to true' do
        @instance.stub(find_instance_user: nil)
        @instance.should_receive(:add_instance_user).with(user: 'user', creator: 'creator', admin: true)
        @instance.add_admin user: 'user', creator: 'creator'
      end
    end

  end

end
