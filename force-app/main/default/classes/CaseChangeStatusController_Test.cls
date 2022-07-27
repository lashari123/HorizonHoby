@isTest
public class CaseChangeStatusController_Test 
{
	@isTest
    static void testChangeCaseStatus()
    {
        List<Account> personAccountList = TestFactory.createPersonAccount(1);
        insert personAccountList;
        
        SystemUtilities.getQueues();
        Id testQueueId;
        for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'HH Customer Support') testQueueId = grp.Id;
        }
        
        List<Case> caseList = TestFactory.createCaseFromContact(personAccountList, testQueueId, 'testfirst0.testlast0@horizonhobby.com', true);
        insert caseList;

        Test.startTest();
        Test.setCurrentPage(Page.CaseChangeStatusToOpen);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(caseList);
        ssc.setSelected(caseList);
        CaseChangeStatus_Controller ccs = new CaseChangeStatus_Controller(ssc);
        ccs.changeStatusToOpen();
        Test.stopTest();
        
    }
    
    
}