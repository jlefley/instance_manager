require 'spec_helper'

describe 'Instance admin authorization' do

  before { sign_in_as_instance_user }

  specify 'create instance registration only accessible to instance admin' do
    post @url + instance_manager.private_user_registration_path, private_user: { email: 'asdf@asdf.com' }, format: :json
    response.status.should == 401
  end

  specify 'new instance registration only accessible to instance admin' do
    get @url + instance_manager.new_private_user_registration_path
    response.should be_redirect
    follow_redirect!
    response.body.downcase.should_not include 'add user'
  end

end
