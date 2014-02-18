Feature: Load seed data into new instance

  @cleandb
  Scenario: Seed data is loaded into instance when created
    Given an instance exists
    And I am associated with an instance as a user
    And I am signed into the instance I am associated with
    When I view data contained in the instance I am associated with
    Then I should see the seed data

  @cleandb
  Scenario: Seed data is loaded into instance when user is confirmed after making account
    Given I have created an instance account
    And I have confirmed my instance account
    And I am signed into the instance I am associated with
    When I view data contained in the instance I am associated with
    Then I should see the seed data
