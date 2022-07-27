@isTest
public with sharing class EmailToCaseHelperTest {
  public EmailToCaseHelperTest() {
  }

  public static List<EmailToCaseWrapper> GetWrappedList() {
    List<EmailToCaseWrapper> wrappedList = new List<EmailToCaseWrapper>{
      new EmailToCaseWrapper(
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
        )
      ),
      new EmailToCaseWrapper(
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
        )
      ),
      new EmailToCaseWrapper(
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
      )
    };
    return wrappedList;
  }

  public static List<EmailToCase__c> GetUnwrappedList() {
    List<EmailToCase__c> unwrapped = new List<EmailToCase__c>{
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
        To_Address__c = '',
        From_Address_Operator__c = '',
        From_Address__c = 'zstevenson@horizonhobby.com',
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
    return unwrapped;
  }

  // @isTest
  // public static void exceptionLoggedOnWrongParamUnwrapList(){
  //   List<EmailToCase__c> e2c= EmailToCaseHelper.unwrapList(null);
  //   List<Exception__c> exs =[SELECT Id FROM Exception__c];
  //   System.assert(exs.size()>0,'Exception List size: '+exs.size());
  // }

  
  @isTest
  public static void exceptionLoggedOnWrongParamSortRules(){
    List<EmailToCase__c> e2c= EmailToCaseHelper.sortRules(null);
    List<Exception__c> exs =[SELECT Id FROM Exception__c];
    System.assert(exs.size()>0,'Exception List size: '+exs.size());
  }

  // @isTest
  // public static void exceptionLoggedOnWrongParamGetSortedRules(){
  //   List<EmailToCase__c> e2c= EmailToCaseHelper.getSortedRules();
  //   List<Exception__c> exs =[SELECT Id FROM Exception__c];
  //   System.assert(exs.size()>0,'Exception List size: '+exs.size());
  // }

  @isTest
  public static void passingWrappedListReturnsSameListUnwrapped() {
    //Arrange
    List<EmailToCaseWrapper> wrappedList = GetWrappedList();
    //Act
    List<EmailToCase__c> unwrapped = EmailToCaseHelper.unwrapList(wrappedList);
    //Assert
    for (EmailToCase__c uw : unwrapped) {
      Integer i = unwrapped.indexOf(uw);
      EmailToCase__c actual = wrappedList[i].e2c;
      System.assertEquals(uw, actual);
    }
  }

  @isTest
  public static void passingUnwrappedListReturnsSameListWrapped() {
    //Arrange
    List<EmailToCase__c> unwrapped = GetUnwrappedList();
    //Act
    List<EmailToCaseWrapper> wrappedList = EmailToCaseHelper.wrapList(
      unwrapped
    );
    //Assert

    for (EmailToCase__c uw : unwrapped) {
      Integer i = unwrapped.indexOf(uw);
      EmailToCase__c actual = wrappedList[i].e2c;
      System.assertEquals(uw, actual);
    }
  }

  @isTest
  public static void passingUnsortedUnwrappedListReturnsSortedUnwrappedList() {
    //Arrange
    List<EmailToCase__c> unsortedunwrapped = GetUnWrappedList();
    Decimal previousPriority = 0;
    Decimal currentPriority = 0;
    //Act
    List<EmailToCase__c> sorted = EmailToCaseHelper.sortRules(
      unsortedunwrapped
    );
    //Assert
    for (EmailToCase__c e2c : sorted) {
      currentPriority = e2c.Priority__c;
      System.assert(currentPriority > previousPriority);
      previousPriority = currentPriority;
    }
  }

  @isTest
  public static void getRulesReturnsEmailToCaseListFromCustomSettings() {
    //Arrange
    insert GetUnwrappedList();
    List<EmailToCase__c> expected = EmailToCase__c.getall().values();
    //Act
    List<EmailToCase__c> rules = EmailToCaseHelper.getRules();
    //Assert
    for (EmailToCase__c actual : rules) {
      Integer i = rules.indexOf(actual);
      System.assertEquals(expected[i].Priority__c, actual.Priority__c);
      System.assertEquals(expected[i].Name, actual.Name);
      System.assertEquals(expected[i].Id, actual.Id);
      System.assertEquals(
        expected[i].Then_Case_Reason__c,
        actual.Then_Case_Reason__c
      );
    }
  }

  @isTest
  public static void checkRuleReturnsTrueWhenValueIsEmptyString() {
    //Arrange
    String value = '';
    String ruleValue = '';
    String ruleOperator = null;
    //Act
    Boolean actual = EmailToCaseHelper.checkRule(
      value,
      ruleValue,
      ruleOperator
    );
    //Assert
    System.assert(actual);
  }

  @isTest
  public static void checkRuleReturnsTrueWhenValueMatchesRule() {
    //Arrange
    String value = 'cheese';
    String ruleValue = 'cheese';
    String ruleOperator = null;
    //Act
    Boolean actual = EmailToCaseHelper.checkRule(
      value,
      ruleValue,
      ruleOperator
    );
    //Assert
    System.assert(actual, 'should be true');
  }

  @isTest
  public static void checkRuleReturnsTrueWhenValueNotContainsRule() {
    //Arrange
    String value = 'ball';
    String ruleValue = 'cheese';
    String ruleOperator = '!contains';
    //Act
    Boolean actual = EmailToCaseHelper.checkRule(
      value,
      ruleValue,
      ruleOperator
    );
    //Assert
    System.assert(actual, 'should be true');
  }

  @isTest
  public static void checkRuleReturnsTrueWhenValueNotEqualRule() {
    //Arrange
    String value = 'ball';
    String ruleValue = 'cheese';
    String ruleOperator = '!=';
    //Act
    Boolean actual = EmailToCaseHelper.checkRule(
      value,
      ruleValue,
      ruleOperator
    );
    //Assert
    System.assert(actual, 'should be true');
  }

  @isTest
  public static void checkRuleReturnsFalseWhenValueDoesNotMatchRule() {
    //Arrange
    String value = 'whiz';
    String ruleValue = 'cheese';
    String ruleOperator = null;
    //Act
    Boolean actual = EmailToCaseHelper.checkRule(
      value,
      ruleValue,
      ruleOperator
    );
    //Assert
    System.assert(!actual);
  }

  @isTest
  public static void checkRuleReturnsTrueeWhenValueMatchesRuleWithConditionalOperator() {
    //Arrange
    String value = 'cheese whiz';
    String ruleValue = 'whiz';
    String ruleOperator = 'contains';
    //Act
    Boolean actual = EmailToCaseHelper.checkRule(
      value,
      ruleValue,
      ruleOperator
    );
    //Assert
    System.assert(actual);
  }

  @isTest
  public static void checkRuleReturnsFalseWhenValueDoesNotMatchRuleWithConditionalOperator() {
    //Arrange
    String value = 'whiz';
    String ruleValue = 'cheese';
    String ruleOperator = 'containx';
    //Act
    Boolean actual = EmailToCaseHelper.checkRule(
      value,
      ruleValue,
      ruleOperator
    );
    //Assert
    System.assert(!actual);
  }

  @isTest
  public static void processEmailToCaseReturnsListOfCasesForListOfEmailMessages() {
    //Arrange
    insert GetUnwrappedList();
    EmailMessage email = new EmailMessage(
      ToAddress = 'test1@email.com',
      FromAddress = 'test1@email.com',
      Subject = 'test1',
      TextBody = 'test1'
    );
    Case newCase = new Case(SuppliedEmail = 'test1@email.com');

    //Act
    Case actual = EmailToCaseHelper.processEmailToCase(email, newCase);
    //Assert

    System.assertEquals(email.FromAddress, actual.SuppliedEmail);
  }

  @isTest
  public static void processEmailToCaseReturnsCaseForListOfEmailMessages() {
    //Arrange
    EmailMessage email = new EmailMessage(
      ToAddress = 'test1@email.com',
      FromAddress = 'zstevenson@horizonhobby.com',
      Subject = 'test1',
      TextBody = 'test1'
    );
    Case newCase = new Case(SuppliedEmail = email.FromAddress);

    //Act
    Case actual = EmailToCaseHelper.processEmailToCase(email, newCase);
    //Assert

    System.assertEquals(email.FromAddress, actual.SuppliedEmail);
  }

  @isTest
  public static void getGroupIdByNameReturnsIdOfMatchingGroup() {
    //Arrange
    List<Group> groups = new List<Group>{
      new Group(Name = 'group1'),
      new Group(Name = 'group2')
    };
    insert groups;
    Id expected = [SELECT Id FROM Group WHERE Name = 'group1'][0].Id;
    //Act
    Id actual = EmailToCaseHelper.getGroupIdByName('group1');
    //Assert
    System.assertEquals(expected, actual);
  }

  @isTest
  public static void getGroupIdByNameNoMatchReturnsNull() {
    //Arrange
    List<Group> groups = new List<Group>{
      new Group(Name = 'group1'),
      new Group(Name = 'group2')
    };
    insert groups;
    Id expected = null;
    //Act
    Id actual = EmailToCaseHelper.getGroupIdByName('cheese');
    //Assert
    System.assertEquals(expected, actual);
  }

  @isTest
  public static void processEmailToCaseReturnsCaseMatchingRule() {
    //Arrange

    List<Group> groups = new List<Group>{
      new Group(Name = 'Product Support'),
      new Group(Name = 'group2')
    };
    insert groups;

    insert GetUnwrappedList();
    EmailMessage email = new EmailMessage(
      ToAddress = 'repairstatus@hobbico.com',
      FromAddress = 'test1@email.com',
      Subject = 'test1',
      TextBody = 'test1'
    );
    Case expected = new Case(
      Reason = 'Repair Status',
      Channel__c = 'tower-us',
      Purchase_Method__c = 'THUS D2C Direct',
      Origin = 'Email to Case',
      Case_Sub_Origin__c = 'Legacy Site',
      Category_List__c = 'General',
      Brand_List__c = null,
      OwnerId = EmailToCaseHelper.getGroupIdByName('Product Support'),
      Department__c = 'Product Support'
    );
    //Act
    Case actual = EmailToCaseHelper.processEmailToCase(email, new Case());
    //Assert
    System.assertEquals(expected.Reason, actual.Reason);
    System.assertEquals(expected.Channel__c, actual.Channel__c);
    System.assertEquals(expected.Purchase_Method__c, actual.Purchase_Method__c);
    System.assertEquals(expected.Origin, actual.Origin);
    System.assertEquals(expected.Case_Sub_origin__c, actual.Case_Sub_origin__c);
    System.assertEquals(expected.Category_List__c, actual.Category_List__c);
    System.assertEquals(expected.Brand_List__c, actual.Brand_List__c);
    System.assertEquals(expected.OwnerId, actual.OwnerId);
    System.assertEquals(expected.Department__c, actual.Department__c);
  }
  @isTest
  public static void processEmailToCaseByEmailAndCaseUpdatesExistingCase() {
    //Arrange
    List<Group> groups = new List<Group>{
      new Group(Name = 'Product Support'),
      new Group(Name = 'group2')
    };
    insert groups;

    List<EmailToCase__c> rules = GetUnwrappedList();
    insert rules;
    EmailMessage email = new EmailMessage(
      ToAddress = 'repairstatus@hobbico.com',
      FromAddress = 'test1@email.com',
      Subject = 'test1',
      TextBody = 'test1'
    );
    // EmailMessage e = [SELECT Id, RelatedToId FROM EmailMessage];

    Case expected = new Case(
      Reason = 'Repair Status',
      Channel__c = 'tower-us',
      Purchase_Method__c = 'THUS D2C Direct',
      Origin = 'Email to Case',
      Case_Sub_Origin__c = 'Legacy Site',
      Category_List__c = 'General',
      Brand_List__c = null,
      OwnerId = EmailToCaseHelper.getGroupIdByName('Product Support'),
      Department__c = 'Product Support',
      Id = email.RelatedToId
    );
    //Act
    Case actual = EmailToCaseHelper.processEmailToCase(email, new Case());
    //Assert
    System.assertEquals(expected.Reason, actual.Reason);
    System.assertEquals(expected.Channel__c, actual.Channel__c);
    System.assertEquals(expected.Purchase_Method__c, actual.Purchase_Method__c);
    System.assertEquals(expected.Origin, actual.Origin);
    System.assertEquals(expected.Case_Sub_origin__c, actual.Case_Sub_origin__c);
    System.assertEquals(expected.Category_List__c, actual.Category_List__c);
    System.assertEquals(expected.Brand_List__c, actual.Brand_List__c);
    System.assertEquals(expected.OwnerId, actual.OwnerId);
    System.assertEquals(expected.Department__c, actual.Department__c);
    System.assertEquals(expected.Id, actual.Id);
  }
}