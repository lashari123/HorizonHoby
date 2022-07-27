/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-23-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-23-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public  class EmailMessageTriggerTest {
     @isTest
    static void ChangeStatusCustomerResponseReceived()
    {
        Id groupId;
        SystemUtilities.getQueues();
		for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'HH Customer Support')
            {
        		groupId = grp.Id;
            }
        }
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'EmailMessageTrigger',isDisabled__c=false);
        Case cs = new Case ();
        cs.suppliedemail = 'abc0@horizonhobby.com';
        cs.origin = 'Web to Case' ;
        cs.OwnerId=groupId;
        cs.Status='Open';
        
        
        insert cs ;
        
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        insert accList;
        List<EmailMessage> EmailList = TestDataFactory.createEmailTest(1);
        EmailList[0].ParentId=cs.id;
        Test.startTest();
        insert EmailList;
        Test.stopTest();
        
    } 
     @isTest
     static void EmailBodyTest()
    {
        Id groupId;
        SystemUtilities.getQueues();
		for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'HH Customer Support')
            {
        		groupId = grp.Id;
            }
        }
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'EmailMessageTrigger',isDisabled__c=false);
        Datetime yesterday = Datetime.now().addDays(-1);
       
       
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        insert accList;
        List<Case> cs = TestDataFactory.createCaseFromContact(accList,groupId);
        cs[0].suppliedemail = 'abc0@horizonhobby.com';
        
        insert cs ;
         for(Case c : cs)
        {
            c.Status = 'Closed';
            c.Sub_Status__c = '';
        }
         update cs;
        system.debug('cs-->'+cs[0].Status);
        List<EmailMessage> EmailList = TestDataFactory.createEmailBodyLengthTest(1);
        EmailList[0].ParentId=cs[0].id;
       
       // Test.setClosedDate(cs.Id, yesterday);
        Test.startTest();
      
       
        insert EmailList;
        Test.stopTest();
        
    }
      @isTest
     static void TestAgent()
    {
        Id groupId;
        SystemUtilities.getQueues();
		for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'HH Customer Support')
            {
        		groupId = grp.Id;
            }
        }
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'EmailMessageTrigger',isDisabled__c=false);
        Datetime yesterday = Datetime.now().addDays(-1);
       
       
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        accList[0].PersonEmail ='customersupport@horizonhobby.com';
        insert accList;
        List<Case> cs = TestDataFactory.createCaseFromContact(accList,groupId);
        cs[0].suppliedemail = 'customersupport@horizonhobby.com';
        
        insert cs ;
        
        List<EmailMessage> EmailList = TestDataFactory.createEmailBodyLengthTest(1);
        EmailList[0].ParentId=cs[0].id;
       
       // Test.setClosedDate(cs.Id, yesterday);
        Test.startTest();
      
      
        insert EmailList;
        Test.stopTest();
        
    }
}