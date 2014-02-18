Given(/^I am a system admin$/) do
  @user = create_system_admin
end

When(/^I sign into the system admin interface$/) do
  sign_in_admin_interface @user
end

Given(/^I have signed into the system admin interface$/) do
  sign_in_admin_interface @user
end

Then(/^I should see the system admin interface$/) do
  page.should have_content(/system admin interface/i)
end

Given(/^I am not a system admin$/) do
  @user = create_private_user
end

Then(/^I should not see the system admin interface$/) do
  page.should_not have_content(/system admin interface/i)
  page.current_url.should_not == main_app.system_admin_index_url
end

Given(/^I have filled out the create instance form in the admin interface with a new user as the instance owner$/) do
  fill_in_new_instance 'test', @new_user_email = 'new_user@example.com'
  @instance = OpenStruct.new
  @instance.name = 'test'
end

When(/^I submit the create instance form$/) do
  click_button 'Create Instance'
end

Then(/^I should see a message indicating successful instance creation$/) do
  page.should have_content(/instance created successfully/i)
end

Given(/^I have filled out the create instance form in the admin interface with an existing user as the instance owner$/) do
  @user = create_private_user
  fill_in_new_instance 'test', @user.email
end

Given(/^I have filled out the create instance form in the admin interface with invalid parameters$/) do
  fill_in_new_instance 'test_inst', 'abc'
end

Then(/^I should see the errors displayed on the form$/) do
  page.should have_content /prohibited/
end

def fill_in_new_instance name, email
  click_link 'Create new instance'
  within '#new_instance' do
    fill_in 'Name', with: name
    fill_in 'Email', with: email
  end
end
