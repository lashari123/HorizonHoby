@isTest
public class FetchAllCasesTest {
    
    @isTest
    public static void testgetAllAccounts() {
        //Bypassing Account Trigger
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=True);
        //Insert Account
        List<Account> accList = TestDataFactory.createPersonAccount(2,'Test');
        insert accList;
        accList[0].GlobalPartyId = '12345';
        accList[1].GlobalPartyId = null;
        update accList;
        
        
        Test.startTest();
        List<Case> accWithPartyId = FetchAllCases.getAllCases(accList[0].Id);
        List<Case> accWithOutPartyId = FetchAllCases.getAllCases(accList[1].Id);
        System.assertEquals('12345', accList[0].GlobalPartyId);
        System.assertEquals(null, accList[1].GlobalPartyId = null);
        Test.stopTest();
    }
}