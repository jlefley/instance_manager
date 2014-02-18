require 'spec_helper'

describe 'Instance user' do
  describe 'when accessing public instance' do
    describe 'when not signed in' do
      it 'should not have access to resource' do
        get main_app.items_path

        response.body.downcase.should_not include 'items index'
      end
    end
    describe 'when signed in as admin' do
      it 'should have access to resource' do
        sign_in_as_public_instance_admin
        
        get main_app.items_path
        
        response.body.downcase.should include 'items index'
      end
    end
    describe 'when signed in as non-admin' do
      it 'should not have access to resource' do
        sign_in_as_public_instance_user
        
        get main_app.items_path
        
        response.body.downcase.should_not include 'items index'
      end
    end
  end

  describe 'when accessing private instance' do
    describe 'when not signed in' do
      it 'should not have access to resource' do
        url = instance_url create_instance
        
        get url + main_app.items_path

        response.body.downcase.should_not include 'items index'
      end
    end
    describe 'when signed in as admin' do
      it 'should have access to resource' do
        sign_in_as_instance_admin

        get @url + main_app.items_path
        
        response.body.downcase.should include 'items index'
      end
    end
    describe 'when signed in as non-admin' do
      it 'should not have access to resource' do
        sign_in_as_instance_user
        
        get @url + main_app.items_path
        
        response.body.downcase.should_not include 'items index'
      end
    end
  end
end
