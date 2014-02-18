When(/^I attempt to sign into the instance I am not associated with$/) do
  sign_in @other_instance, @user
end

Then(/^I should not be signed into the instance$/) do
  page.should have_content /sign in/i
  page.should_not have_content /test application index/i
  page.should_not have_content @user.email
end

When(/^I sign into the instance I am associated with$/) do
  sign_in @instance, @user
end

Then(/^I should be signed into the instance$/) do
  page.should have_content /signed in successfully/i
  page.should have_content /test application index/i
  page.should have_content @user.email
end

Given(/^I have confirmed my account$/) do
  steps %Q{
    And I have visited the confirmation url for my account
    And I have entered in a password
    When I submit the confirmation form
  }
  @user = find_private_user email: @new_user_email
end

Given(/^I am an existing user who has been added to an instance$/) do
  steps %Q{
    Given an instance exists
    And I am associated with an instance as an admin
    And I am signed into the instance I am associated with
    
    When I visit the instance admin interface
    Then I should see the instance admin interface

    When I add an existing user to the instance
    Then I should see a confirmation message indicating that the user has been added to the instance
  }
  click_link 'Sign out'
end

Given(/^I am signed into the instance I am associated with$/) do
  steps %Q{
    When I sign into the instance I am associated with
    Then I should be signed into the instance
  }
end

When(/^I visit the url of an instance I am not associated with$/) do
  visit instance_url @other_instance
end
