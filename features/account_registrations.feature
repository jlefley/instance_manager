Feature: Account registration

  @email
  Scenario: Anonymous user creates account
    Given I have filled out the new account form with valid parameters
    When I submit the new account form
    Then I should see a message stating that I will receive a confirmation link
    And an account activation email should be sent to the specified email address

  Scenario: Anonymous user attempts to create account with invalid parameters
    Given I have filled out the new account form with invalid parameters
    When I submit the new account form
    Then I should see the errors preventing the action 
