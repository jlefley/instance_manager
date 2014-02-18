require 'unit_spec_helper'
require 'active_support/core_ext/object/blank'
require 'instance_manager/constraints/public_domain_required'

module InstanceManager; end

describe InstanceManager::Constraints::PublicDomainRequired do

  let(:constraint) { InstanceManager::Constraints::PublicDomainRequired }
  let(:request) { double 'request' }

  before do
    InstanceManager.stub(public_domain: '1slate.com')
  end

  describe 'when request domain is equal to the configured public domain' do
    before do
      request.stub(domain: '1slate.com')
    end

    describe 'when subdomain is present and not www' do
      it 'should not match' do
        request.stub(subdomain: 'asdf')
        constraint.matches?(request).should == false
      end
    end
    
    describe 'when subdoman is www' do
      it 'should match' do
        request.stub(subdomain: 'www')
        constraint.matches?(request).should == true
      end
    end

    describe 'when subdomain is not present' do
      it 'should match' do
        request.stub(subdomain: nil)
        constraint.matches?(request).should == true
      end
    end

  end
  
  describe 'when request domain is not equal to the configured public domain' do
    it 'should not match' do
      request.stub(domain: 'example.com')
      constraint.matches?(request).should == false
    end
  end

end
