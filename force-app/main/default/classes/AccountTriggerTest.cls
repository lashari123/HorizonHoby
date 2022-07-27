@isTest
public class AccountTriggerTest {
    //Test case to associate account to case when account is inserted based on supplied email
    @isTest
    Public Static Void TestSuppliedEmail()
    {
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        Case cs = new Case ();
        cs.suppliedemail = 'abc0@horizonhobby.com';
        cs.origin = 'Web to Case' ;
        insert cs ;
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
      
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        System.debug('accList------->'+accList);
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        Case C = [Select id, accountid from case where accountid =:accList[0].id];
        system.assertEquals(accList[0].id,C.accountid);
    } 
     @isTest
    Public Static Void TestAlternateEmail()       //Test case to associate account to case when account is inserted based on AlternateEmail
    {
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        Case cs = new Case ();
        cs.suppliedemail = 'abc0@horizonhobby.com';
        cs.origin = 'Web to Case' ;
        insert cs ;
        Case cs1 = new Case ();
        cs1.suppliedemail = 'xyz@test.com';
        cs1.origin = 'Web to Case' ;
        insert cs1 ;
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
      
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        accList[0].Email2__pc='xyz@test.com';
        System.debug('accList------->'+accList);
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        system.assertEquals([select accountId from case where id =: cs1.id].accountId,accList[0].id);
       
    } 
     @isTest
    Public Static Void TestHistoricEmail()  //Test case to associate account to case when account is inserted based on HistoricEmail
    {
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        Case cs = new Case ();
        cs.suppliedemail = 'abc0@horizonhobby.com';
        cs.origin = 'Web to Case' ;
        insert cs ;
        Case cs1 = new Case ();
        cs1.suppliedemail = 'xyz@test.com';
        cs1.origin = 'Web to Case' ;
        insert cs1 ;
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
      
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        accList[0].Email3__pc='xyz@test.com';
        System.debug('accList------->'+accList);
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        system.assertEquals([select accountId from case where id =: cs1.id].accountId,accList[0].id);
    } 
    //Test case to for Email update on account
    @isTest
    Public Static Void TestUpdateSuppliedEmail()
    {
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        Case cs = new Case ();
        cs.suppliedemail = 'xyz@test.com';
        cs.origin = 'Web to Case' ;
        insert cs ;
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
      
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        insert accList;
        
        Test.startTest();
        accList[0].PersonEmail='xyz@test.com';
        Update accList;
        Test.stopTest();
        
        Case C = [Select id, accountid from case where accountid =:accList[0].id];
        system.assertEquals(accList[0].id,C.accountid);
        
    }
     @isTest
    Public Static Void TestUpdateHistoricEmail() //Test case to associate account to case when account is updated with HistoricEmail
    {
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        Case cs = new Case ();
        cs.suppliedemail = 'xyz@test.com';
        cs.origin = 'Web to Case' ;
        insert cs ;
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
      
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        insert accList;
        
        Test.startTest();
        accList[0].Email3__pc='xyz@test.com';
        Update accList;
        Test.stopTest();
        
        Case C = [Select id, accountid from case where accountid =:accList[0].id];
        system.assertEquals(accList[0].id,C.accountid);
        
    }
     @isTest
    Public Static Void TestUpdateAlternateEmail() //Test case to associate account to case when account is updated with Alternate Email
    {
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        Case cs = new Case ();
        cs.suppliedemail = 'xyz@test.com';
        cs.origin = 'Web to Case' ;
        insert cs ;
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
      
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        insert accList;
        
        Test.startTest();
        accList[0].Email2__pc='xyz@test.com';
        Update accList;
        Test.stopTest();
        
        Case C = [Select id, accountid from case where accountid =:accList[0].id];
        system.assertEquals(accList[0].id,C.accountid);
        
    }
    // Test case to check Non matching email in account and case
    @isTest
    Public Static VOid TestNonMatchEmail()
    {
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        Case cs = new Case ();
        cs.suppliedemail = 'xyz@abc.com';
        cs.origin = 'Web to Case' ;
        insert cs ;
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        
        List<Account> accList = TestDataFactory.createPersonAccount(1,'abc');
        
        Test.startTest();
        insert accList;   
        Test.stopTest();
        
        Case C = [Select id, accountid,suppliedemail from case where suppliedemail ='xyz@abc.com'];
        system.assertNotEquals(accList[0].id,C.accountid);
        
    }
   
    
}