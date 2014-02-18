Given(/^an instance exists$/) do
  @instance = create_instance
end

Given(/^I am associated with an instance as an admin$/) do
  @user = create_instance_admin @instance
end

When(/^I visit the instance admin interface$/) do
  visit instance_url(@instance) + instance_manager.instance_admin_index_path
end

Then(/^I should see the instance admin interface$/) do
  page.should have_content /instance admin interface/i
end

Given(/^I am associated with an instance as a user$/) do
  @user = create_instance_user @instance
end

Then(/^I should not see the instance admin interface$/) do
  page.should_not have_content /instance admin interface/i
end

When(/^I add a new user to the instance$/) do
  click_link 'Add user'
  fill_in 'Email', with: @new_user_email = 'new_user@example.com'
  click_button 'Add user'
end

Then(/^an account activation email should be sent to the specified email address$/) do
  assert_confirmation_email @instance, find_private_user(email: @new_user_email)
end

Then(/^I should see a confirmation message indicating that an activation email has been sent$/) do
  page.should have_content /confirmation link has been sent/i
end

When(/^I add an existing user to the instance$/) do
  @user = create_private_user 
  click_link 'Add user'
  fill_in 'Email', with: @user.email
  click_button 'Add user'
end

Then(/^I should see a confirmation message indicating that the user has been added to the instance$/) do
  page.should have_content /#{@user.email} has been added to this instance/i
end

Given(/^I have visted the admin interface for an instance I am associated with as an admin$/) do
  steps %{
    Given an instance exists
    And I am associated with an instance as an admin
    And I am signed into the instance I am associated with
    When I visit the instance admin interface
    Then I should see the instance admin interface
  }
end

When(/^I upload an image for use as the application logo$/) do
  click_link 'Set logo'
  attach_file('instance_logo', "#{InstanceManager::Engine.root}/features/fixtures/test_logo.png")
  click_button 'Upload file'
end

Then(/^the logo should be set as the uploaded image$/) do
  page.find('img')['src'].should have_content @instance.name
end
