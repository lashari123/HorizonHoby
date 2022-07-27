global with sharing class EmailToCaseWrapper implements Comparable {
  public EmailToCase__c e2c;
  public EmailToCaseWrapper(EmailToCase__c emailToCase) {
    e2c = emailToCase;
  }

  global Integer compareTo(Object compareTo) {
    // Cast argument to OpportunityWrapper
    EmailToCaseWrapper compareToE2C = (EmailToCaseWrapper) compareTo;

    // The return value of 0 indicates that both elements are equal.
    Integer returnValue = 0;
    if (e2c.Priority__c > compareToE2C.e2c.Priority__c) {
      // Set return value to a positive value.
      returnValue = 1;
    } else if (e2c.Priority__c < compareToE2C.e2c.Priority__c) {
      // Set return value to a negative value.
      returnValue = -1;
    }

    return returnValue;
  }
}