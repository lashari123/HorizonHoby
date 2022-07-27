@isTest
public class CloseCaseController_Test 
{
    @isTest
	static void testCloseCases()
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
        
        List<Account> testPersAcctList = TestFactory.createPersonAccount(25);
        insert testPersAcctList;
        
        List<Case> testCaseList = TestFactory.createCaseFromContact(testPersAcctList, groupId, '', false);
        insert(testCaseList);
        
        Test.startTest();
        Test.setCurrentPage(Page.CloseCases);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(testCaseList);
        stdSetController.setSelected(testCaseList);
        CloseCase_Controller closeCsCtrl = new CloseCase_Controller(stdSetController);
        closeCsCtrl.setCaseStatusToClosed();
        Test.stopTest();
    }
    
}