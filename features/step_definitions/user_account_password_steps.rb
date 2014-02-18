When(/^I request a reset password link at the instance I am associated with$/) do
  request_password_reset @instance, @user
end

When(/^I request a reset password link at the instance I am not associated with$/) do
  request_password_reset @other_instance, @user
end

Then(/^I should receive an email with the reset password link$/) do
  assert_password_recovery_email @instance, @user
end

Given(/^I have requested a reset password link$/) do
  @new_password = '123456bB'
  request_password_reset @instance, @user
end

When(/^I change my password within a subdomain I am associated with$/) do
  change_password @instance, @user.send_reset_password_instructions, @new_password
end

Then(/^my password should be changed$/) do
  page.should have_content /password was changed successfully/i
  click_link 'Sign out'
  sign_in @instance, @user, @new_password
  steps 'Then I should be signed into the instance'
end

When(/^I attempt to change my password within a subdomain I am not associated with$/) do
  change_password @other_instance, @user.send_reset_password_instructions, @new_password
end

Then(/^my password should not be changed$/) do
  page.should have_content /invalid/i
  sign_in @instance, @user
  steps 'Then I should be signed into the instance'
end
