Feature: User account confirmation

  Scenario: User confirms account that does not already have a password set at instance the user is associated with
    Given I am a new user who has been added to an instance
    And I have visited the confirmation url for my account
    And I have entered in a password
    When I submit the confirmation form
    Then my account should be confirmed
    And I should be able to sign in

  Scenario: User sets invalid password when confirming account that does not already have a password set
    Given I am a new user who has been added to an instance
    And I have visited the confirmation url for my account
    And I have entered in an invalid password
    When I submit the confirmation form
    Then I should see the errors preventing the action 

  Scenario: User attempts to confirm account at instance the user is not associated with
    Given I am a new user who has been added to an instance
    When I visit the confirmation url for my account at an instance I am not associated with
    Then my account should not be confirmed

  Scenario: User confirms account that already has a password set
    Given I have created an instance account
    When I visit the confirmation url for my account
    Then my account should be confirmed
    And I should be able to sign in
    
  @email
  Scenario: User requests confirmation link resend at instance the user is not associated with
    Given I am a new user who has been added to an instance
    When I request my confirmation link to be resent through an instance I am not associated with
    Then I should not receive any email
    And I should see a message stating that if my account is found I will receive a confirmation link

  @email
  Scenario: User requests confirmation link resend at instance the user is associated with
    Given I am a new user who has been added to an instance
    When I request my confirmation link to be resent through an instance I am associated with
    Then an account activation email should be sent to the specified email address
    And I should see a message stating that if my account is found I will receive a confirmation link
