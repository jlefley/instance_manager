Then(/^I should see the seed data$/) do
  page.should have_content /seed thing/i
end

Given(/^I have confirmed my instance account$/) do
  steps %(When I visit the confirmation url for my account)
end
