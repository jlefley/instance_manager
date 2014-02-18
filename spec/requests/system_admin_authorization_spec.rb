require 'spec_helper'

describe 'System admin authorization' do

  before do
    sign_in_as_instance_user
    @url = 'http://admin.example.com'
  end

  specify 'create instance only accessible to system admin' do
    post @url + instance_manager.instances_path, instance: { name: 'asdf' }, format: :json
    response.status.should == 401
  end

  specify 'new instance only accessible to system admin' do
    get @url + instance_manager.new_instance_path
    response.should be_redirect
    follow_redirect!
    response.body.downcase.should_not include 'create new instance'
    response.body.downcase.should include 'sign in'
  end

  specify 'system admin interface not accessible to non system admin signed into other instance' do
    get @url + main_app.system_admin_index_path
    response.should be_redirect
    follow_redirect!
    response.body.downcase.should include 'sign in'
  end

end
