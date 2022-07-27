@isTest
public class CaseTriggerTest {
  @isTest
    static void testUpdateCaseWithNewAccount()
    {
         insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        accList[0].Channel__pc ='horizon-us';
		insert accList;
        // Do not insert accounts yet
        
        List<Case> testCaseList = TestDataFactory.createTestEmailToCase(1,'abc');
     
        
        Test.startTest();
        insert testCaseList;
        Test.stopTest();
    }
    @isTest
    static void testUpdateCaseWithSiteName()
    {
         insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        accList[0].Channel__pc ='horizon-us';
        accList[0].Email2__pc ='xyz0@horizonhobby.com';
		insert accList;
        
       
        List<Case> testCaseList = TestDataFactory.createTestSiteNameCase(1,'xyz');
                              
        
        Test.startTest();
        insert testCaseList;
        Test.stopTest();
    }
     @isTest
    static void testUpdateCaseWithHistoricEmail()
    {
         insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        accList[0].Channel__pc ='horizon-us';
        accList[0].Email3__pc ='xyz0@horizonhobby.com';
		insert accList;
        
       
        List<Case> testCaseList = TestDataFactory.createTestSiteNameCase(1,'xyz');
                              
        
        Test.startTest();
        insert testCaseList;
        Test.stopTest();
    }
    @isTest
    static void testUpdateCaseWithOriginWebtocase()
    {
         insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        accList[0].Channel__pc ='horizon-us';
        accList[0].Email2__pc ='xyz0@horizonhobby.com';
		insert accList;
        
        // List<Case> alltestCaseList=new List<Case>();
        
                             List<Case> alltestCaseList=new List<Case>();
        List<String> ReasonList=new List<String>{'Technical Product Support','Repair Status','Place an Order','My Account / Club Question','Easy Pay or Payment Question','Order Status','Customers outside the US / Canada','Return Request','Change / Cancel Order','Another issue'};
            List<String> ChannelList =new List<String>{'horizon-us','horizon-eu','tower-us','tower-us','tower-us','tower-us','tower-us','tower-us','tower-us','tower-us'};
      alltestCaseList= TestDataFactory.createChatToCase('HH Consumer Sales','Chat to Case',ChannelList,ReasonList);
        
        
                     
        
        
        Test.startTest();
        insert alltestCaseList;
        Test.stopTest();
    }
    
     @isTest
    static void testWebtoCase()
    {         insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
		ContactTrgTest.TestUpdateSuppliedEmail();
        TestDataFactory.createWebToCase('Web to Case','My Account or RC Club question','tower-us');
        TestDataFactory.createWebToCase('Web to Case','My Account or RC Club question','horizon-us');
        TestDataFactory.createWebToCase('Web to Case','My Account or RC Club question','horizon-eu');


    }

}