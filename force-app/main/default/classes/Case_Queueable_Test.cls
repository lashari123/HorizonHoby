@isTest
public class Case_Queueable_Test 
{

    @isTest
    static void testCaseQueueableProcesses()
    {
        SystemUtilities.getQueues();
        SystemUtilities.getQueueSobjects();
        
        Map<Id, Group> caseQueuesToTest = new Map<Id, Group>();
        for(QueueSobject qs : SystemUtilities.queueSobjects.values())
        {
            if(qs.SobjectType == 'Case')
            {
            	caseQueuesToTest.put(qs.QueueId, SystemUtilities.queueMap.get(qs.QueueId));
            }
        }
        
        List<Account> personAccountList1 = TestFactory.createPersonAccount(1);
        personAccountList1[0].Channel__pc = 'horizon-us';
        insert personAccountList1;
        
        List<Case> testCaseList = new List<Case>();
        for(Group caseQueue : caseQueuesToTest.values())
        {

            if(caseQueue.Name == 'Athearn')
            {
            	List<Case> testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, personAccountList1[0].PersonEmail, true);
                testCaseList.addAll(testCases);
            }
            else if(caseQueue.Name == 'HH Consumer Sales')
            {
            	List<Case> testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, personAccountList1[0].PersonEmail, true);
                testCaseList.addAll(testCases);
            }
            else if(caseQueue.Name == 'HH Customer Support')
            {
                List<Case> testCases = new List<Case>();
            	testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, personAccountList1[0].PersonEmail, true);
                testCaseList.addAll(testCases);
                
            	testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, 'test@marketplace.amazon.com', true);
                testCaseList.addAll(testCases);
                
            	testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, 'test@members.ebay.com', true);
                testCaseList.addAll(testCases);
                
            	testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, 'test@relay.walmart.com', true);
                testCaseList.addAll(testCases);
            }
            else if(caseQueue.Name == 'Omni eBay')
            {
            	List<Case> testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, personAccountList1[0].PersonEmail, true);
                testCaseList.addAll(testCases);
            }
            else if(caseQueue.Name == 'Product Support')
            {
            	List<Case> testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, personAccountList1[0].PersonEmail, true);
                testCaseList.addAll(testCases);
            }
            else if(caseQueue.Name == 'Sales EU')
            {
                List<Case> testCases = new List<Case>();
            	testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, personAccountList1[0].PersonEmail, true);
                testCaseList.addAll(testCases);
                
            	testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, 'test@marketplace.amazon.com', true);
                testCaseList.addAll(testCases);
            }
            else if(caseQueue.Name == 'Tech Support EU')
            {
            	List<Case> testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, personAccountList1[0].PersonEmail, true);
                testCaseList.addAll(testCases);
            }
            else if(caseQueue.Name == 'TH Customer Support')
            {
            	List<Case> testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, personAccountList1[0].PersonEmail, true);
                testCaseList.addAll(testCases);
            }
            else if(caseQueue.Name == 'TH Sales')
            {
            	List<Case> testCases = TestFactory.createCaseFromContact(personAccountList1, caseQueue.Id, personAccountList1[0].PersonEmail, true);
                testCaseList.addAll(testCases);
            }
        }
            
        insert testCaseList;
    
	}
        
}