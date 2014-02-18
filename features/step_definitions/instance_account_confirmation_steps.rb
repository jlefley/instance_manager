Given(/^I have created an instance account$/) do
  steps %{  
    Given I have filled out the new account form with valid parameters
    When I submit the new account form
    Then I should see a message stating that I will receive a confirmation link
  }
end

When(/^I visit the confirmation url for my account$/) do
  @user = find_private_user email: @new_user_email
  visit_confirmation_link @instance, @user
end
