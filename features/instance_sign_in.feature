Feature: Instance sign in

  Scenario: Non-instance user attempts to sign into instance
    Given multiple instances exist
    And I am associated with an instance as a user
    When I attempt to sign into the instance I am not associated with
    Then I should not be signed into the instance

  Scenario: Instance user signs into instance
    Given an instance exists
    And I am associated with an instance as a user
    When I sign into the instance I am associated with
    Then I should be signed into the instance

  Scenario: New user added to instance can sign into instance after confirmation
    Given I am a new user who has been added to an instance
    And I have confirmed my account
    When I sign into the instance I am associated with
    Then I should be signed into the instance

  Scenario: Existing user added to instance can sign into instance
    Given I am an existing user who has been added to an instance
    When I sign into the instance I am associated with
    Then I should be signed into the instance

  Scenario: Signed in user attempts to access an instance the user is not associated with
    Given multiple instances exist
    And I am associated with an instance as a user
    And I am signed into the instance I am associated with
    When I visit the url of an instance I am not associated with
    Then I should not be signed into the instance
