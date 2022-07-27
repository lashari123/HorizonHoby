@isTest
public with sharing class EmailMessageTriggerHelperTest {
  public EmailMessageTriggerHelperTest() {
  }

  public static String customerEmail = 'sjack@horizonhobby.com';
  public static String firstName = 'Samurai';
  public static String lastName = 'Jack';

  public static void SetupTest() {
    Id accountrecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('Person Account')
      .getRecordTypeId();
    insert new TriggerSetting__c(Name = 'CaseTrigger', isDisabled__c = false);
    insert new TriggerSetting__c(
      Name = 'AccountTrigger',
      isDisabled__c = false
    );
    insert new TriggerSetting__c(
      Name = 'EmailMessageTrigger',
      isDisabled__c = false
    );
    insert new Account(
      FirstName = firstName,
      LastName = lastName,
      PersonEmail = customerEmail,
      Channel__pc = 'horizon-us',
      RecordTypeId = accountrecordtypeid
    );
  }

  @isTest
  public static void EmailContainingThanksReopensExistingClosedCase() {
    // Arrange
    SetupTest();
    Account acct = [
      SELECT Id
      FROM Account
      WHERE PersonEmail = :customerEmail
    ][0];
    Case testCase = new Case(
      SuppliedEmail = customerEmail,
      SuppliedName = firstName + ' ' + lastName,
      Status = 'closed',
      Subject = 'Aku stole my katana',
      Account = acct
    );
    System.debug('insert testCase');
    insert testCase;

    List<Case> caselist = new List<Case>();
    caselist.add(testCase);

    Id testCaseId = [
      SELECT Id
      FROM Case
      WHERE SuppliedEmail = :customerEmail
    ][0]
    .Id;

    System.debug('testCaseId');
    System.debug(testCaseId);
    EmailMessage reply = new EmailMessage(
      ToAddress = 'productsupport@horizonhobby.com',
      FromAddress = customerEmail,
      Subject = 'RE: Aku stole my katana',
      TextBody = 'I\'ll thank you to return it.',
      ParentId = testCaseId
    );
    // Act

    System.debug('insert reply');

    insert reply;
    Case actualCase = [
      SELECT Id, Status, IsClosed
      FROM Case
      WHERE SuppliedEmail = :customerEmail
      LIMIT 1
    ];
    System.debug('actualCase');
    System.debug(actualCase);
    // Assert
    System.assert(!actualCase.IsClosed);
  }
  @isTest
  public static void CustomerEmailWaitingOnReplySetsStatusToCustomerResponseRecieved() {
    // Arrange
    SetupTest();
    Account acct = [
      SELECT Id
      FROM Account
      WHERE PersonEmail = :customerEmail
    ][0];
    Case testCase = new Case(
      SuppliedEmail=customerEmail,
      SuppliedName = firstName + ' ' + lastName,
      Auto_Closed__c=false,
      Status = 'Waiting for Customer Reply',
      Subject = 'Aku stole my katana',
      Account = acct
    );
    System.debug('insert testCase');
    insert testCase;

    List<Case> caselist = new List<Case>();
    caselist.add(testCase);

    Id testCaseId = [
      SELECT Id
      FROM Case][0].Id;

    System.debug('testCaseId');
    System.debug(testCaseId);
    EmailMessage reply = new EmailMessage(
      ToAddress = 'productsupport@horizonhobby.com',
      FromAddress = customerEmail,
      Subject = 'RE: Aku stole my katana',
      TextBody = 'I\'ll thank you to return it.',
      ParentId = testCaseId
    );
    // Act

    System.debug('insert reply');

    insert reply;
    Case actualCase = [
      SELECT Id, Status, IsClosed
      FROM Case
      LIMIT 1
    ][0];
    System.debug('actualCase');
    System.debug(actualCase);
    // Assert
    System.assert(!actualCase.IsClosed);
    System.assertEquals('Customer Response Received', actualCase.Status);
  }

}