@isTest
public class CaseAutoClose_Batchable_Test 
{
    static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    @isTest
    static void testAutoCloseCase()
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
        
        List<Account> testAccountList = TestFactory.createPersonAccount(20);
        insert testAccountList;
        
        List<Case> testCaseList = TestFactory.createCaseFromContact(testAccountList, groupId, '', false);
        insert testCaseList;
        
        for(Case cs : testCaseList)
        {
            cs.Status = 'Open';
            cs.Sub_Status__c = 'Open: Need Customer reply';
        }
        
        update testCaseList;
        
        Set<Id> caseIds = new Set<Id>();
        for(Case cs : testCaseList)
        {
            caseIds.add(cs.Id);
        }
        
        Test.startTest();
        	
        CaseAutoClose_Schedulable caseAutoClose = new CaseAutoClose_Schedulable();
        caseAutoClose.testIds = caseIds;
        
        String jobId = System.schedule('CaseAutoCloseScheduleTest',
        CRON_EXP, 
        caseAutoClose);
        
        Test.stopTest();
        
    }
}