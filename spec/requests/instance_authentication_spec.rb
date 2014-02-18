require 'spec_helper'

describe 'Instance user' do

  describe 'when viewing resource requiring authentication for public and private instance users' do
    # Resource is things index

    describe 'when resource is in public instance' do
      describe 'when signed in' do
        it 'should be able to view resource' do
          sign_in_as_public_instance_user

          get main_app.things_path
          
          response.body.downcase.should include 'things'
        end
      end

      describe 'when not signed in' do
        it 'should not be able to view resource' do
          get main_app.things_path
          
          response.body.downcase.should_not include 'things'
        end
      end
    end

    describe 'when resource is in private instance' do
      describe 'when signed in' do
        it 'should be able to view resource' do
          sign_in_as_instance_user
          
          get @url + main_app.things_path
          
          response.body.downcase.should include 'things'
        end
      end

      describe 'when not signed in' do
        it 'should not be able to view resource' do
          url = instance_url create_instance

          get url + main_app.things_path
          
          response.body.downcase.should_not include 'things'
        end
      end
    end

  end

  describe 'when viewing resource requiring authentication for private instance users but not for public instance users' do
    # Resource is main index

    describe 'when resource is in public instance' do
      describe 'when signed in' do
        it 'should be able to view resource' do
          sign_in_as_public_instance_user

          get main_app.root_path
          
          response.body.downcase.should include 'application index'
        end
      end

      describe 'when not signed in' do
        it 'should be able to view resource' do
          get main_app.root_path
          
          response.body.downcase.should include 'application index'
        end
      end
    end

    describe 'when resource is in private instance' do
      describe 'when signed in' do
        it 'should be able to view resource' do
          sign_in_as_instance_user
          
          get @url + main_app.root_path
          
          response.body.downcase.should include 'application index'
        end
      end

      describe 'when not signed in' do
        it 'should not be able to view resource' do
          url = instance_url create_instance

          get url + main_app.root_path
          
          response.body.downcase.should_not include 'application index'
        end
      end
    end

  end

end
