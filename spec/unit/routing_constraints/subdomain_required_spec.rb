require 'unit_spec_helper'
require 'instance_manager/constraints/subdomain_required'
require 'active_support/core_ext/object/blank'

describe InstanceManager::Constraints::SubdomainRequired do

  let(:constraint) { InstanceManager::Constraints::SubdomainRequired }
  let(:request) { double 'request' }

  describe 'when request contains subdomain and subdomain is not www' do
    it 'should match' do
      request.stub(subdomain: 'inst')
      constraint.matches?(request).should == true
    end
  end
  
  describe 'when request does not contain subdomain' do
    it 'should not match' do
      request.stub(subdomain: nil)
      constraint.matches?(request).should == false
    end
  end
  
  describe 'when request subdomain is www' do
    it 'should not match' do
      request.stub(subdomain: 'www')
      constraint.matches?(request).should == false
    end
  end


end
