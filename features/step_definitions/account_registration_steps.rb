Given(/^I have filled out the new account form with valid parameters$/) do
  visit instance_manager.new_account_path
  fill_in 'Email', with: @new_user_email = 'new_user@example.com'
  fill_in 'Password', with: '123456aA'
  fill_in 'Password confirmation', with: '123456aA'
  fill_in 'First name', with: 'John'
  fill_in 'Last name', with: 'Doe'
  fill_in 'Organization', with: 'Someplace'
  fill_in 'Phone', with: '999-999-9999'
  fill_in 'Name', with: 'thename'
end

When(/^I submit the new account form$/) do
  click_button 'Create Account'
end

Then(/^I should see a message stating that I will receive a confirmation link$/) do
  page.should have_content /check email for confirmation link/i
  @instance = InstanceManager::Instance.first name: 'thename'
end

Given(/^I have filled out the new account form with invalid parameters$/) do
  visit instance_manager.new_account_path
  fill_in 'Email', with: 'new_account'
end
