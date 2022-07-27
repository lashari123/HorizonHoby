@isTest
public class ContactTrgTest {
    
    @isTest
    Public Static Void TestUpdateSuppliedEmail()
    {
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8',FirstName='Automated',LastName='Process', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardhorizon@testorg.com');
        
        System.runAs(u) {
                    insert new TriggerSetting__c(Name = 'ContactTrg',isDisabled__c=false);
                    insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);

            		Contact contactObj = new Contact();
            		contactObj.FirstName='Test';
            		contactObj.LastName='Horizon';
                    contactObj.Email='xyz0@horizonhobby.com';
            		insert contactObj;

        }
    }
}