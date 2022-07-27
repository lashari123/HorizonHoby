@isTest
public without sharing class FoorterController_Test {

    
    static testMethod void testgetManagerDetails(){
       Account acc = new Account (
            Name = 'levis'
        );   
        insert acc;
       contact cont = new contact();
        cont.AccountId = acc.Id;
        cont.FirstName = 'Test fname';
        cont.LastName = 'Test lname';
        cont.Email = 'test@test.com';
        cont.Phone = '123456789';
        cont.AccountId = acc.Id;
        cont.WeekDayTiming__c = '1600 pm';
        cont.WeekEndTiming__c = '1400 pm';
    
        insert cont;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        
 Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus v2' LIMIT 1];
       
       User userRecord = new User(
            			
            			   LastName = 'LIVESTON',
                           FirstName ='JASON',
                           Username  = 'jason.liveston@najammm.com',
                           CompanyName = 'Jasonprivatelimited',
                           Email = 'jason.liveston@asdf.com',
            			   Alias = 'jasonAA',
            			   TimeZoneSidKey = 'GMT',
            		       LocaleSidKey = 'en_US', 
                           EmailEncodingKey = 'UTF-8', 
                           LanguageLocaleKey = 'en_US',
                           Phone = '+2121212',
                           MobilePhone = '+213123',
                           ProfileId = ProfileId.id,
            			   ContactID = cont.id
                           );
       
        insert (userRecord);
        acc.Manager__c = userRecord.Id;
        Update acc;
        
            if(cont != null){
                if(cont.Account.Manager__c != null){
                    String managerID = cont.Account.Manager__c;
                    Contact con = new Contact();
                    con.FirstName = 'Test fname1';
                    con.LastName = 'Test lname2';
                    con.Email = 'test@gmail.com';
                    con.WeekDayTiming__c = cont.WeekDayTiming__c;
                    con.WeekEndTiming__c = cont.WeekEndTiming__c;
                    insert con;
                }
            }
        System.runAs ( thisUser ) {
       footerController.getManagerDetails(userRecord.Id);
    } 
    
}
}