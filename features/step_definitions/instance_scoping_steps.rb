Given(/^multiple instances exist$/) do
  @other_instance = create_instance
  @instance = create_instance
end

And(/^data scoped to the instances exists$/) do
  OSTools::Schema.switch @instance.id, false
  @instances_thing = Thing.create name: "Instance's thing"
  OSTools::Schema.switch @other_instance.id, false
  @other_instances_thing = Thing.create name: "Other instance's thing"
  OSTools::Schema.reset
end

When(/^I view data contained in the instance I am associated with$/) do
  visit instance_url(@instance) + main_app.things_path
end

Then(/^I should see data contained in my instance$/) do
  page.should have_content @instances_thing.name
end

Then(/^I should not see data contained the other instance$/) do
  page.should_not have_content @other_instances_thing.name
end
