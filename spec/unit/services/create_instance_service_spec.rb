require 'unit_spec_helper'
require 'create_instance_service'

describe InstanceManager::CreateInstanceService do

  let(:user_repository) { double 'user repository' }
  let(:instance_repository) { double 'instance repository' }
  let(:schema_tools) { double 'schema tools' }
  let(:user) { double 'user' }
  let(:instance) { double 'instance' }

  before do
    instance.stub(id: 55)
    instance.stub(:add_admin)
    instance.stub(owner: user)
    instance.stub(save: false)

    user_repository.stub(find: nil)
    
    schema_tools.stub(:create_schema)
    
    @service =
      InstanceManager::CreateInstanceService.new user: user_repository, instance: instance_repository, schema_tools: schema_tools
  end

  describe 'when creating instance' do
 
    let(:existing_owner_attributes) { { name: 'new_inst', owner_attributes: { email: ' test@test.com  ' } } }
    let(:attributes) { { name: 'new_inst', owner_attributes: { email: 'test@test.com' } } }
    
    describe 'when specified owner exists' do
      before do
        user_repository.stub(:find).with(email: 'test@test.com').and_return(user)
        instance_repository.stub(:new).with(name: 'new_inst').and_return(instance)
      end
      it 'should associate the existing user as the owner of the new instance' do
        instance.stub(:save)
        
        instance.should_receive(:owner=).with(user)
        
        @service.command existing_owner_attributes, 'current_user'
      end
      it 'should save the instance' do
        instance.stub(:owner=)
        
        instance.should_receive(:save)
        
        @service.command existing_owner_attributes, 'current_user'
      end
    end
    
    describe 'when specified owner does not exist' do
      it 'should save a new instance created with the nested owner attributes' do
        instance_repository.stub(:new).with(name: 'new_inst', owner_attributes: { email: 'test@test.com' }).and_return(instance)
        
        instance.should_receive(:save)
        
        @service.command attributes, 'current_user'
      end
    end
   
    describe 'when instance is saved' do
      before do
        instance_repository.stub(new: instance)
        instance.stub(save: true)
        schema_tools.stub(:create_schema)
        schema_tools.stub(:load_seed)
      end
      it 'should create a schema for the instance' do
        schema_tools.should_receive(:create_schema).with('55')
        
        @service.command attributes, 'current_user'
      end
      it 'should add the owner as an admin' do
        instance.should_receive(:add_admin).with(user: user, creator: 'current_user')
        
        @service.command attributes, 'current_user'
      end
      it 'should load seed data' do
        schema_tools.should_receive(:load_seed).with('55')
        
        @service.command attributes, 'current_user'
      end
    end

    describe 'when instance is not saved' do
      before do
        instance_repository.stub(new: instance)
      end
      it 'should not create a schema for the instance' do
        schema_tools.should_not_receive(:create_schema)
        @service.command attributes, 'current_user'
      end
      it 'should not add the owner as an admin' do
        instance.should_not_receive(:add_admin)
        @service.command attributes, 'current_user'
      end
    end

    it 'should return the new instance' do
      instance_repository.stub(new: instance)
      
      @service.command(attributes, 'current_user').should == instance
    end
  end
end
