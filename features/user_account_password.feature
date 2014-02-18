Feature: User account password

  @email
  Scenario: User requests reset password link at instance the user is associated with
    Given an instance exists
    And I am associated with an instance as a user
    When I request a reset password link at the instance I am associated with
    Then I should receive an email with the reset password link

  @email
  Scenario: User requests reset password link at instance the user is not associated with
    Given multiple instances exist
    And I am associated with an instance as a user
    When I request a reset password link at the instance I am not associated with
    Then I should not receive any email

  Scenario: User resets password at instance the user is associated with
    Given an instance exists
    And I am associated with an instance as a user
    And I have requested a reset password link
    When I change my password within a subdomain I am associated with
    Then my password should be changed

  Scenario: User attempts to reset password at instance the user is not associated with
    Given multiple instances exist
    And I am associated with an instance as a user
    And I have requested a reset password link
    When I attempt to change my password within a subdomain I am not associated with
    Then my password should not be changed
