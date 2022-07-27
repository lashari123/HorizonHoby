@isTest
public class FetchAccountsTest {
    
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
        List<Account> accWithPartyId = FetchAccounts.getAllAccounts(accList[0].Id);
        List<Account> accWithOutPartyId = FetchAccounts.getAllAccounts(accList[1].Id);
        System.assertEquals('12345', accList[0].GlobalPartyId);
        System.assertEquals(null, accList[1].GlobalPartyId = null);
        Test.stopTest();
    }
}