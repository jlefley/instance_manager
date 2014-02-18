Feature: Instance admin

  Scenario: Instance admin accesses instance admin interface
    Given an instance exists
    And I am associated with an instance as an admin
    And I am signed into the instance I am associated with
    When I visit the instance admin interface
    Then I should see the instance admin interface

  Scenario: Non-admin attempts to access instance admin interface
    Given an instance exists
    And I am associated with an instance as a user
    And I am signed into the instance I am associated with
    When I visit the instance admin interface
    Then I should not see the instance admin interface

  @email
  Scenario: Instance admin adds new user to instance through admin interface
    Given I have visted the admin interface for an instance I am associated with as an admin
    When I add a new user to the instance
    Then I should see a confirmation message indicating that an activation email has been sent
    And an account activation email should be sent to the specified email address

  Scenario: Instance admin adds existing user to instance through admin interface
    Given I have visted the admin interface for an instance I am associated with as an admin
    When I add an existing user to the instance
    Then I should see a confirmation message indicating that the user has been added to the instance

  Scenario: Instance admin uploads logo image through admin interface
    Given I have visted the admin interface for an instance I am associated with as an admin
    When I upload an image for use as the application logo
    Then the logo should be set as the uploaded image
