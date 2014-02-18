Feature: Instance scoping

  Scenario: Instance user views their instance
    Given multiple instances exist
    And data scoped to the instances exists
    And I am associated with an instance as a user
    And I am signed into the instance I am associated with
    When I view data contained in the instance I am associated with
    Then I should see data contained in my instance
    And I should not see data contained the other instance
