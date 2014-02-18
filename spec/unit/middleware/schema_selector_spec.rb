require 'rack/request'
require 'active_support/core_ext/object/blank'
require 'unit_spec_helper'
require 'schema_selector'

module InstanceManager; class Instance; end; end

describe InstanceManager::SchemaSelector do

  let(:app) { double 'app' }
  let(:schema_tools) { double 'schema tools' }
  let(:instance) { InstanceManager::Instance }
  let(:current_instance) { double 'current instance' }

  before do
    InstanceManager.stub(public_instance_schema: 'os')
    InstanceManager.stub(public_domain: 'example.com')
    InstanceManager.stub(restricted_subdomains: ['admin'])
    app.stub(:call)
    @middleware = InstanceManager::SchemaSelector.new app, schema_tools
  end

  it 'should call app with environment hash' do
    schema_tools.stub(:reset)
    app.should_receive(:call).with('env')
    @middleware.call('env')
  end

  describe 'when host domain matches configured public domain' do
    before { instance.stub(:first_with_id).with(name: 'example').and_return(current_instance) }
    it 'should switch the search path to the schema for the public instance' do
      schema_tools.should_receive(:switch).with('os', false)
      @middleware.call({ 'SERVER_NAME' => 'example.com' })
    end
    it 'should set a key in the environment hash containing the retrieved instance' do
      schema_tools.stub(:switch)
      @middleware.call(env = { 'SERVER_NAME' => 'example.com' })
      
      env['current_instance'].should == current_instance
    end
  end

  describe 'when host domain does not match configured public domain' do

    describe 'when host includes subdomain' do

      describe 'when subdomain is associated with existing instance' do

        describe 'when subdomain is not in restricted subdomain list' do
          before do
            current_instance.stub(id: 4)
            instance.stub(:first_with_id).with(name: 'inst').and_return(current_instance)
          end

          it 'should switch the search path to the schema for the matching instance' do
            schema_tools.should_receive(:switch).with(4, false)
            
            @middleware.call({ 'SERVER_NAME' => 'inst.domain.com' })
          end
          
          it 'should set a key in the environment hash containing the retrieved instance' do
            schema_tools.stub(:switch)
            @middleware.call(env = { 'SERVER_NAME' => 'inst.domain.com' })
            
            env['current_instance'].should == current_instance
          end

          describe 'when exception is raised when attempting to set search path' do
            it 'should reset the search path' do
              schema_tools.stub(:switch).and_raise(StandardError) 
              
              schema_tools.should_receive(:reset)
              
              @middleware.call({ 'SERVER_NAME' => 'inst.domain.com' })
            end
          end
        end
        
        describe 'when subdomain is in restricted subdomain list' do
          before do
            instance.stub(:first_with_id).with(name: 'admin').and_return(current_instance)
          end

          it 'should reset the search path' do
            schema_tools.should_receive(:reset)
            
            @middleware.call({ 'SERVER_NAME' => 'admin.domain.com' })
          end
          
          it 'should set a key in the environment hash containing the retrieved instance' do
            schema_tools.stub(:reset)
            @middleware.call(env = { 'SERVER_NAME' => 'admin.domain.com' })
            
            env['current_instance'].should == current_instance
          end
        end
      
      end
      
      describe 'when subdomain is not associated with existing instance' do
        it 'should reset the schema search path' do
          instance.stub(first_with_id: nil)
          schema_tools.should_receive(:reset)
          @middleware.call({ 'SERVER_NAME' => 'not-an-inst.domain.com' })
        end
      end

    end

    describe 'when host does not include subdomain' do
      it 'should reset the schema search path' do
        schema_tools.should_receive(:reset)
        @middleware.call({ 'SERVER_NAME' => 'domain.com' })
      end
    end

  end

end
