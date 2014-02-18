Feature: System admin

  Scenario: System admin views system admin interface
    Given I am a system admin
    When I sign into the system admin interface
    Then I should see the system admin interface

  Scenario: Non-admin attempts to view system admin interface
    Given I am not a system admin
    When I sign into the system admin interface
    Then I should not see the system admin interface

  @email
  Scenario: System admin creates instance with new user account
    Given I am a system admin
    And I have signed into the system admin interface
    And I have filled out the create instance form in the admin interface with a new user as the instance owner
    When I submit the create instance form
    Then I should see a message indicating successful instance creation
    And an account activation email should be sent to the specified email address

  Scenario: System admin creates instance with existing user account
    Given I am a system admin
    And I have signed into the system admin interface
    And I have filled out the create instance form in the admin interface with an existing user as the instance owner
    When I submit the create instance form
    Then I should see a message indicating successful instance creation

  Scenario: System admin creates instance with invalid attributes
    Given I am a system admin
    And I have signed into the system admin interface
    And I have filled out the create instance form in the admin interface with invalid parameters
    When I submit the create instance form
    Then I should see the errors displayed on the form
