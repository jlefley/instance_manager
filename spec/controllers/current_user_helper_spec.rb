require 'spec_helper'

describe ApplicationController do

  describe 'when getting current user' do
    describe 'when there is no user signed in' do
      describe 'when request host contains subdomain' do
        it 'should return nil' do
          @request.host = 'abc.' + @request.host
          @controller.send(:current_user).should == nil
        end
      end
      describe 'when request host contains public domain' do
        it 'should return nil' do
          @request.host = InstanceManager.public_domain
          @controller.send(:current_user).should == nil
        end
      end
    end

    describe 'when a private instance user is signed in and the request host is a private subdomain' do
      it 'should return the current private user' do
        sign_in :private_user, user = create_private_user
        @request.host = 'abc.' + @request.host
        @controller.send(:current_user).should == user
      end
    end

    describe 'when a public instance user is signed in and the request host is the public domain' do
      it 'should return the current public user' do
        sign_in :public_user, user = create_public_user
        @request.host = InstanceManager.public_domain
        @controller.send(:current_user).should == user
      end
    end
  end

end
