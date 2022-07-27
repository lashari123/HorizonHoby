@isTest
public class EmailMessageTriggers_Test 
{

    @isTest
    static void testReopenClosedCases()
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
        
        List<Account> accountList = TestFactory.createPersonAccount(1);
        insert accountList;
        
        List<Case> caseList1 = TestFactory.createCaseFromContact(accountList, groupId, '', false);
        insert caseList1;
        
        EmailMessage em1 = new EmailMessage();
        em1.FromAddress = accountList[0].PersonEmail;
        em1.ToAddress = 'customersupport@horizonhobby.com';
        em1.ParentId = caseList1[0].Id;
        em1.Subject = 'Test inbound customer email';
        em1.TextBody = 'Test inbound customer email';
        
        insert em1;
        
        EmailMessage em2 = new EmailMessage();
        em2.FromAddress = 'customersupport@horizonhobby.com';
        em2.ToAddress = accountList[0].PersonEmail;
        em2.ParentId = caseList1[0].Id;
        em2.Subject = 'Test outbound to customer email 2';
        em2.TextBody = 'Test outbound to customer email 2';        
        
        insert em2;
        
        for(Case cs : caseList1)
        {
            cs.Status = 'Closed';
            cs.Sub_Status__c = '';
        }
		
        update caseList1;
        
        
        EmailMessage em3 = new EmailMessage();
        em3.FromAddress = accountList[0].PersonEmail;
        em3.ToAddress = 'customersupport@horizonhobby.com';
        em3.ParentId = caseList1[0].Id;
        em3.Subject = 'Test inbound customer email 3';
        em3.TextBody = 'Test inbound customer email 3';
        
        test.startTest();
        
        insert em3;
        
        test.stopTest();
        
        Case testCase = [SELECT Id, Status, Sub_Status__c FROM Case WHERE Id = :caseList1[0].Id];
        System.assertEquals('Open: Customer Revived Ticket', testCase.Sub_Status__c);
    }
    
}