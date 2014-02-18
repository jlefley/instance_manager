Given(/^I have visited the confirmation url for my account$/) do
  click_link 'Sign out'
  @user = find_private_user email: @new_user_email
  visit_confirmation_link @instance, @user
end

Given(/^I have entered in a password$/) do
  fill_in 'Password', with: '123456aA'
  fill_in 'Password confirmation', with: '123456aA'
end

When(/^I submit the confirmation form$/) do
  click_button 'Confirm Account'
end

Then(/^my account should be confirmed$/) do
  page.should have_content /your account was successfully confirmed. please sign in./i
end

Then(/^I should be able to sign in$/) do
  steps %Q{
    When I sign into the instance I am associated with
    Then I should be signed into the instance
  }
end

Given(/^I have entered in an invalid password$/) do
  fill_in 'Password', with: '1234'
end

Then(/^I should see the errors preventing the action$/) do
  page.should have_content /errors prohibited/i
end

Given(/^I am a new user who has been added to an instance$/) do
  steps %Q{
    Given an instance exists
    And I am associated with an instance as an admin
    And I am signed into the instance I am associated with
    
    When I visit the instance admin interface
    Then I should see the instance admin interface

    When I add a new user to the instance
    Then I should see a confirmation message indicating that an activation email has been sent
  }
end

When(/^I visit the confirmation url for my account at an instance I am not associated with$/) do
  click_link 'Sign out'
  @user = find_private_user email: @new_user_email
  visit_confirmation_link @other_instance = create_instance, @user
end

Then(/^my account should not be confirmed$/) do
  visit instance_url(@other_instance) + instance_manager.new_private_user_session_path
  page.should_not have_content @user.email
  @user.refresh.confirmation_token.should_not be_nil
end

When(/^I request my confirmation link to be resent through an instance I am not associated with$/) do
  request_confirmation_link create_instance, @new_user_email
 end

When(/^I request my confirmation link to be resent through an instance I am associated with$/) do
  request_confirmation_link @instance, @new_user_email
end

Then(/^I should not receive any email$/) do
  ActionMailer::Base.deliveries.should be_empty
end

Then(/^I should see a message stating that if my account is found I will receive a confirmation link$/) do
  page.should have_content /exists in our database, you will receive an email/i
end
