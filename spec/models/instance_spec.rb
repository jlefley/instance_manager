require 'spec_helper'

describe InstanceManager::Instance do

  before do
    @instance = InstanceManager::Instance.new(name: 'test')
  end

  subject { @instance }

  it { should be_valid }

  describe 'when name is blank' do
    before { @instance.name = '  ' }
    it { should_not be_valid }
  end

  describe 'when name is not unique' do
    before do
      instance = InstanceManager::Instance.new(name: 'test')
      instance.owner = create_private_user
      instance.save
    end
    it { should_not be_valid }
  end

  describe 'when name is in reserved list' do
    before { @instance.name = 'admin' }
    it { should_not be_valid }
  end

end

