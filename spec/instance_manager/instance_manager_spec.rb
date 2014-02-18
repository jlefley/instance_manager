require 'spec_helper'

describe 'Instance manager' do

  let(:public_instance_schema) { InstanceManager.public_instance_schema }
  let(:default_schema) { OSTools.default_schema }

  describe 'when checking if current schema is the default schema' do
    describe 'when search path is set to default schema' do
      it 'should return true' do
        OSTools::Schema.switch default_schema, false
        InstanceManager.current_schema_default?.should == true
      end
    end
    describe 'when search path is not set to default schema' do
      it 'should return false' do
        OSTools::Schema.switch public_instance_schema, false
        InstanceManager.current_schema_default?.should == false
      end
    end
  end

  describe 'when checking if current schema is the public instance schema' do
    describe 'when search path is set to public instance schema' do
      it 'should return true' do
        OSTools::Schema.switch public_instance_schema, false
        InstanceManager.current_schema_public?.should == true
      end
    end
    describe 'when search path is not set to public instance schema' do
      it 'should return false' do
        OSTools::Schema.switch default_schema, false
        InstanceManager.current_schema_public?.should == false
      end
    end
  end

  describe 'when getting qualified users table name' do
    describe 'when search path is set to public instance schema' do
      it 'should return users table name qualified with public instance schema' do
        OSTools::Schema.switch public_instance_schema, false
        InstanceManager.qualified_users_table.should == "#{public_instance_schema}__users".to_sym
      end
    end
    describe 'when search path is not set to public instance schema' do
      it 'should return users table name qualified with default schema' do
        OSTools::Schema.switch default_schema, false
        InstanceManager.qualified_users_table.should == "#{default_schema}__users".to_sym
      end
    end
  end

end
