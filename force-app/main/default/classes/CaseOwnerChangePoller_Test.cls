@isTest
public with sharing class CaseOwnerChangePoller_Test 
{
    @isTest
    static void testCaseOwnerChangePoller()
    {
        SystemUtilities.getQueues();

        User psUser = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'US Product Support' LIMIT 1];

        List<Account> persAcctList = TestFactory.createPersonAccount(1);
        insert persAcctList;

        List<Case> caseList = TestFactory.createCaseFromContact(persAcctList, SystemUtilities.queueMapByName.get('Product Support').Id, 'test@gmail.com', false);
        insert caseList;

        //CaseOwnerChangePoller.getCurrentUser(psUser.Id);
        CaseOwnerChangePoller.getCurrentUser();
        CaseOwnerChangePoller.getCaseOwner(caseList[0].Id);

        System.runAs(psUser)
        {
            CaseOwnerChangePoller.changeCaseOwner(caseList[0].Id);
        }
    }
}