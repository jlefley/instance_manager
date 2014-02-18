require 'unit_spec_helper'
require 'complete_instance_creation_service'

describe InstanceManager::CompleteInstanceCreationService do

  let(:user_repository) { double 'user repository' }
  let(:user) { double 'user' }
  let(:instance) { double 'instance' }
  let(:schema_tools) { double 'schema tools' }

  before do
    user.stub(id: 2)
    @service = InstanceManager::CompleteInstanceCreationService.new schema_tools: schema_tools, user: user_repository
  end

  describe 'when handling user confirmation' do
   
    describe 'when current instance is nil' do
      it 'should not complete instance creation' do
        @service.command(user, nil)
      end
    end

    describe 'when user is the owner of the current instance' do
      before { instance.stub(user_id: 2, id: 5) }

      describe 'when user is not already confirmed' do
        before { user.stub(confirmed?: false) }

        it 'should generate a schema for the instance' do
          schema_tools.stub(:load_seed)

          schema_tools.should_receive(:create_schema).with('5')
          @service.command(user, instance)
        end
        it 'should load the seed data into the instance' do
          schema_tools.stub(:create_schema)
          
          schema_tools.should_receive(:load_seed).with('5')
          @service.command(user, instance)
        end

      end
      describe 'when user is already confirmed' do

        it 'should not complete instance creation' do
          user.stub(confirmed?: true)
          @service.command(user, instance)
        end

      end
    end
    
    describe 'when user is not the owner of the current instance' do

      it 'should not complete instance creation' do
        instance.stub(user_id: 3)
        @service.command(user, instance)
      end

    end
  end
end
