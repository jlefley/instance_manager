require 'model_spec_helper'
require 'account'

describe InstanceManager::Account do

  before do
    @account = InstanceManager::Account.new first_name: 'abc', last_name: 'def'
  end

  subject { @account }

  it { should be_valid }

  describe 'when setting phone number attribute' do
    it 'should remove non digit characters from specified value' do
      @account.phone_number = '111-222'
      @account.phone_number.should == 111222
    end
  end

  describe 'when first name is blank' do
    before { @account.first_name = '  ' }
    it { should_not be_valid }
  end

  describe 'when last name is blank' do
    before { @account.last_name = '  ' }
    it { should_not be_valid }
  end

end
