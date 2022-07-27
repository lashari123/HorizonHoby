@isTest
public class OrderDetailsFetchTest {

    // Method to test calloutToGoServer() method
    @isTest
    public static void testcalloutToGoServer() {
        //Bypassing Account Trigger
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=True);
        //Insert Account
        List<Account> accList = TestDataFactory.createPersonAccount(2,'mockTest');
        insert accList;
        insert new OrderHistoryAPi__c(Name='Order_History_APi_Details',Password__c='OpenSesame',URL__c='https://apis-tst.horizonhobby.com/HHERP.SVC/orders?$filter=Customer/ContactId+in+',Username__c='Aladdin');

        accList[0].GlobalPartyId = '12345';
        accList[1].GlobalPartyId = null;
        update accList;
        
        OrderDetailsFetch.orderWraper wrapr = new OrderDetailsFetch.orderWraper();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OrderDetailsFetchMock());
        Object result = OrderDetailsFetch.calloutToGoServer(accList[0].Id);
        Object resultWithoutPartyId = OrderDetailsFetch.calloutToGoServer(accList[1].Id);
        System.assertEquals('12345', accList[0].GlobalPartyId);
        System.assertEquals(null, accList[1].GlobalPartyId = null);
        Test.stopTest();
               
    }    
}