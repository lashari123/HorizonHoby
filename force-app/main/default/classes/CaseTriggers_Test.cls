@isTest
public class CaseTriggers_Test 
{
  /*  @isTest
    static void testUpdateCaseContact()
    {
        SystemUtilities.getQueues();
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        List<Account> persAcctTest = TestFactory.createPersonAccount(1);
        persAcctTest[0].Channel__pc = 'horizon-us';
        insert persAcctTest;
        
        List<Case> testCaseList = TestFactory.createTestEmailToCase(201, '@horizonhobby.com');

		for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'Athearn')
            {
                testCaseList[0].OwnerId = grp.Id;
            }
            else if(grp.Name == 'HH Consumer Sales')
            {
                testCaseList[1].OwnerId = grp.Id;
            }
            else if(grp.Name == 'HH Customer Support')
            {
        		testCaseList[2].OwnerId = grp.Id;
            }
            else if(grp.Name == 'Omni eBay')
            {
                testCaseList[3].OwnerId = grp.Id;
            }
            else if(grp.Name == 'Product Support')
            {
                testCaseList[4].OwnerId = grp.Id;
            }
            else if(grp.Name == 'Sales EU')
            {
                testCaseList[5].OwnerId = grp.Id;
            }
            else if(grp.Name == 'Tech Support EU')
            {
                testCaseList[6].OwnerId = grp.Id;
            }
            else if(grp.Name == 'TH Customer Support')
            {
                testCaseList[7].OwnerId = grp.Id;
            }
            else if(grp.Name == 'TH Sales')
            {
                testCaseList[8].OwnerId = grp.Id;
            }
        }
        
        Test.startTest();
        
        insert testCaseList;
        Test.stopTest();
        
    }
    
    @isTest
    static void testUpdateCaseWithNewAccount()
    {
        SystemUtilities.getQueues();
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        List<Account> persAcctTest = TestFactory.createPersonAccount(1);
        persAcctTest[0].Channel__pc = 'horizon-us';
		
        // Do not insert accounts yet
        
        List<Case> testCaseList = TestFactory.createTestEmailToCase(201, '@horizonhobby.com');

		for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'Athearn')
            {
                testCaseList[0].OwnerId = grp.Id;
            }
            else if(grp.Name == 'HH Consumer Sales')
            {
                testCaseList[1].OwnerId = grp.Id;
            }
            else if(grp.Name == 'HH Customer Support')
            {
        		testCaseList[2].OwnerId = grp.Id;
            }
            else if(grp.Name == 'Omni eBay')
            {
                testCaseList[3].OwnerId = grp.Id;
            }
            else if(grp.Name == 'Product Support')
            {
                testCaseList[4].OwnerId = grp.Id;
            }
            else if(grp.Name == 'Sales EU')
            {
                testCaseList[5].OwnerId = grp.Id;
            }
            else if(grp.Name == 'Tech Support EU')
            {
                testCaseList[6].OwnerId = grp.Id;
            }
            else if(grp.Name == 'TH Customer Support')
            {
                testCaseList[7].OwnerId = grp.Id;
            }
            else if(grp.Name == 'TH Sales')
            {
                testCaseList[8].OwnerId = grp.Id;
            }
        }
        
        insert testCaseList;
        
        Test.startTest();
        
        insert persAcctTest;
        
        Test.stopTest();
    }
    
 /*   @isTest
    static void testUpdateCaseContactWithBusiness()
    {
        SystemUtilities.getQueues();
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        List<Account> businessAcctTest = TestFactory.createBusinessAccount(2);
        //businessAcctTest[0].Channel__c = 'horizon-us';
        insert businessAcctTest;

        Database.DMLOptions dml = new Database.DMLOptions(); 
		dml.DuplicateRuleHeader.AllowSave = true;
        
        List<Contact> contactList1 = TestFactory.createContacts(businessAcctTest[0].Id, 1, '@horizonhobby.com');
        database.insert(contactList1, dml);
        
        List<Contact> contactList2 = TestFactory.createContacts(businessAcctTest[1].Id, 1, '@horizonhobby2.com');
        database.insert(contactList2, dml);
        
        List<Case> testCaseList = TestFactory.createTestEmailToCase(201, '@horizonhobby.com');

		for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'Athearn')
            {
                testCaseList[0].OwnerId = grp.Id;
            }
            else if(grp.Name == 'HH Consumer Sales')
            {
                testCaseList[1].OwnerId = grp.Id;
            }
            else if(grp.Name == 'HH Customer Support')
            {
        		testCaseList[2].OwnerId = grp.Id;
            }
            else if(grp.Name == 'Omni eBay')
            {
                testCaseList[3].OwnerId = grp.Id;
            }
            else if(grp.Name == 'Product Support')
            {
                testCaseList[4].OwnerId = grp.Id;
            }
            else if(grp.Name == 'Sales EU')
            {
                testCaseList[5].OwnerId = grp.Id;
            }
            else if(grp.Name == 'Tech Support EU')
            {
                testCaseList[6].OwnerId = grp.Id;
            }
            else if(grp.Name == 'TH Customer Support')
            {
                testCaseList[7].OwnerId = grp.Id;
            }
            else if(grp.Name == 'TH Sales')
            {
                testCaseList[8].OwnerId = grp.Id;
            }
        }
        
        Test.startTest();
        
        insert testCaseList;
        
        Case caseToUpdate1 = [SELECT Id, AccountId, ContactId FROM Case WHERE Id = :testCaseList[0].Id];
        System.debug('Test Business Account AccountId: ' + caseToUpdate1.AccountId);
        
        System.debug('Contact List 2: ' + contactList2[0].AccountId);
        caseToUpdate1.AccountId = contactList2[0].AccountId;
        caseToUpdate1.ContactId = contactList2[0].Id;
        update caseToUpdate1;
        
        System.debug('Contact List 1: ' + contactList1[0].AccountId);
        caseToUpdate1.AccountId = contactList1[0].AccountId;
        update caseToUpdate1;
        
        Test.stopTest();
    }
    
  /*  @isTest
    static void testCaseAutoCloseDateUpdate()
    {
        SystemUtilities.getQueues();
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        List<Account> persAcctTest = TestFactory.createPersonAccount(1);
        persAcctTest[0].Channel__pc = 'horizon-us';
        insert persAcctTest;
        
        List<Case> testCaseList = TestFactory.createTestEmailToCase(5, '@horizonhobby.com');
		for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'HH Customer Support')
            {
        		testCaseList[0].OwnerId = grp.Id;
                testCaseList[1].OwnerId = grp.Id;
                testCaseList[2].OwnerId = grp.Id;
                testCaseList[3].OwnerId = grp.Id;
                testCaseList[4].OwnerId = grp.Id;
            }
        }

        insert testCaseList;
        
		Case_Auto_Close_Date__mdt[] autoCloseDays = [SELECT Auto_Close_After_Days__c FROM Case_Auto_Close_Date__mdt LIMIT 1];
        
        Test.startTest();

        // Check if the auto-close date is populated
        for(Case cs : testCaseList)
        {
            cs.Status = 'Open';
            cs.Sub_Status__c = 'Open: Need Customer reply';
        }
        
        update testCaseList;
        
        List<Case> casesToCheck = new List<Case>([SELECT Id, Status, Auto_Close_Date__c FROM Case]);
        for(Case cs : casesToCheck)
        {
            System.assert(cs.Auto_Close_Date__c == Date.today() + (Integer)autoCloseDays[0].Auto_Close_After_Days__c);
        }
        
        // Check if the auto-close date is now null
        for(Case cs : testCaseList)
        {
            cs.Status = 'Open';
            cs.Sub_Status__c = 'Open: Customer Responded';
        }
        
        update testCaseList;
        
        casesToCheck = new List<Case>([SELECT Id, Status, Auto_Close_Date__c FROM Case]);
        for(Case cs : casesToCheck)
        {
            System.assert(cs.Auto_Close_Date__c == null);
        }
        
        Test.stopTest();
    }
    */
    @isTest
    static void testCopyWebToCaseMessage()
    {
        SystemUtilities.getQueues();
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        List<Account> persAcctTest = TestFactory.createPersonAccount(1);
        persAcctTest[0].Channel__pc = 'horizon-us';
        insert persAcctTest;
        
        List<Case> testCaseList = TestFactory.createTestEmailToCase(5, '@horizonhobby.com');
		for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'HH Customer Support')
            {
        		testCaseList[0].OwnerId = grp.Id;
                testCaseList[0].Form_Message__c = 'Test Web to Case Message';
                
            }
        }

        insert testCaseList;
    }
    
    /*
    @isTest
    static void testReassociateOpenCases()
    {
        SystemUtilities.getQueues();
        
        List<Account> persAcctTest = TestFactory.createPersonAccount(1);
        persAcctTest[0].Channel__pc = 'horizon-us';
        insert persAcctTest;
        
        List<Case> testCaseList1 = TestFactory.createTestEmailToCase(1);
		for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'HH Customer Support')
            {
        		testCaseList1[0].OwnerId = grp.Id;
            }
        }

        insert testCaseList1;
        
        List<Case> testCaseList2 = TestFactory.createTestEmailToCase(1);
		for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'HH Customer Support')
            {
        		testCaseList2[0].OwnerId = grp.Id;
            }
        }
        
        Test.startTest();
        
        insert testCaseList2;
        
        List<Case> caseList = new List<Case>([SELECT Id, ParentId FROM Case WHERE Id IN :testCaseList2]);
        
        System.assertEquals(testCaseList1[0].Id, caseList[0].ParentId);
        
        Test.stopTest();
    }
    */
    
    @isTest
    static void testUpdateCaseDepartment()
    {
        SystemUtilities.getQueues();
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        List<Account> persAcctTest = TestFactory.createPersonAccount(1);
        persAcctTest[0].Channel__pc = 'horizon-us';
        insert persAcctTest;
        
        List<Case> testCaseList1 = TestFactory.createTestEmailToCase(1, '@horizonhobby.com');
        
        Id customerSupportQueueId;
        Id productSupportQueueId;
        
		for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'HH Customer Support')
            {
        		//testCaseList1[0].OwnerId = grp.Id;
        		customerSupportQueueId = grp.Id;
            }
            else if(grp.Name == 'Product Support')
            {
                productSupportQueueId = grp.Id;
            }
        }
        
        testCaseList1[0].OwnerId = customerSupportQueueId;
        
        Test.startTest();
        
        SystemUtilities.resetExecuted('CaseTriggers.updateCaseFields');
        insert testCaseList1;
        
        Case csDepartment1 = [SELECT Id, OwnerId, Department__c FROM Case WHERE Id = :testCaseList1[0].Id];
        //System.debug(csDepartment1.OwnerId);
        //System.assertEquals('HH Customer Support', csDepartment1.Department__c);
        
        testCaseList1[0].OwnerId = productSupportQueueId;
        SystemUtilities.resetExecuted('CaseTriggers.updateCaseFields');
        update testCaseList1;
        
        Case csDepartment2 = [SELECT Id, OwnerId, Department__c FROM Case WHERE Id = :testCaseList1[0].Id];
        //System.debug(csDepartment1.OwnerId);
        //System.assertEquals('Product Support', csDepartment1.Department__c);
        
        Test.stopTest();
        
    }
    
}