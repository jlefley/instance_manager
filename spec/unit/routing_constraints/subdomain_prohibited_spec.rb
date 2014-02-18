require 'unit_spec_helper'
require 'instance_manager/constraints/subdomain_prohibited'
require 'active_support/core_ext/object/blank'

describe InstanceManager::Constraints::SubdomainProhibited do

  let(:constraint) { InstanceManager::Constraints::SubdomainProhibited }
  let(:request) { double 'request' }

  describe 'when request does not contain a subdomain' do
    it 'should match' do
      request.stub(subdomain: nil)
      constraint.matches?(request).should == true
    end
  end
  
  describe 'when request contains subdomain' do
    it 'should not match' do
      request.stub(subdomain: 'asdf')
      constraint.matches?(request).should == false
    end
  end
  
  describe 'when request subdomain is www' do
    it 'should match' do
      request.stub(subdomain: 'www')
      constraint.matches?(request).should == true
    end
  end


end
