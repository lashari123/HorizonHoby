@isTest
public class CaseCreateCustomerController_Test 
{
    @isTest
    static void testCreateCustomer()
    {
		Case cs = new Case();
        cs.SuppliedName = 'TestFirst1 TestLast1';
        cs.SuppliedEmail = 'testfirst1+testlast2@test.com';
        cs.Subject = 'Test Subject 1';
        cs.Description = 'Test Description';
        cs.Origin = 'Email to Case';
        cs.Inquiry_Type__c = 'I would like to return a product';
        cs.Site_Name__c = 'horizon-us';
        
        insert cs;
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        CaseCreateCustomer_Controller ccc = new CaseCreateCustomer_Controller(sc);
        ccc.openCreateAccount();
        
        Test.stopTest();
        
    }
}