@isTest
public with sharing class EmailToCaseWrapperTest {
  public EmailToCaseWrapperTest() {
  }

  @isTest
  public static void callingSortOnListOfEmailToCaseWrapperSortsListByPriority() {
    //Arrange
    insert new TriggerSetting__c(
      Name = 'EmailMessageTrigger',
      isDisabled__c = false
    );
    List<EmailToCase__c> unwrappedList = new List<EmailToCase__c>{
      new EmailToCase__c(
        Priority__c = 106,
        Enabled__c = true,
        To_Address_Operator__c = '',
        To_Address__c = 'productsupport@hobbico.com',
        From_Address_Operator__c = '',
        From_Address__c = '',
        Subject_Operator__c = '',
        Subject__c = '',
        Then_Case_Reason__c = 'Tech Product Support',
        Then_Channel__c = 'tower-us',
        Then_Purchase_Method__c = 'THUS D2C Direct',
        Then_Case_Origin__c = 'Email to Case',
        Then_Case_Sub_Origin__c = 'Legacy Site',
        Then_Category_List__c = 'General',
        Name = 'General-62',
        Then_Brand_List__c = '',
        Then_Owner__c = 'Product Support',
        Then_Department__c = 'Product Support'
      ),
      new EmailToCase__c(
        Priority__c = 108,
        Enabled__c = true,
        To_Address_Operator__c = '',
        To_Address__c = 'support@hobbico.com',
        From_Address_Operator__c = '',
        From_Address__c = '',
        Subject_Operator__c = '',
        Subject__c = '',
        Then_Case_Reason__c = 'Tech Product Support',
        Then_Channel__c = 'tower-us',
        Then_Purchase_Method__c = 'THUS D2C Direct',
        Then_Case_Origin__c = 'Email to Case',
        Then_Case_Sub_Origin__c = 'Legacy Site',
        Then_Category_List__c = 'General',
        Name = 'General-64',
        Then_Brand_List__c = '',
        Then_Owner__c = 'Product Support',
        Then_Department__c = 'Product Support'
      ),
      new EmailToCase__c(
        Priority__c = 107,
        Enabled__c = true,
        To_Address_Operator__c = '',
        To_Address__c = 'repairstatus@hobbico.com',
        From_Address_Operator__c = '',
        From_Address__c = '',
        Subject_Operator__c = '',
        Subject__c = '',
        Then_Case_Reason__c = 'Repair Status',
        Then_Channel__c = 'tower-us',
        Then_Purchase_Method__c = 'THUS D2C Direct',
        Then_Case_Origin__c = 'Email to Case',
        Then_Case_Sub_Origin__c = 'Legacy Site',
        Then_Category_List__c = 'General',
        Name = 'General-63',
        Then_Brand_List__c = '',
        Then_Owner__c = 'Product Support',
        Then_Department__c = 'Product Support'
      )
    };
    List<EmailToCaseWrapper> wrappedList = new List<EmailToCaseWrapper>();
    for (EmailToCase__c unwrapped : unwrappedList) {
      wrappedList.add(new EmailToCaseWrapper(unwrapped));
    }
    //Act
    wrappedList.sort();
    //Assert
    System.assert(
      wrappedList[0].e2c.Priority__c < wrappedList[1].e2c.Priority__c,
      'priority on first item should be smaller number than second item.'
    );
  }
}