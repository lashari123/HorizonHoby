@isTest
public class footerControllerTest {
    public static testMethod void userIdTest() {
        List <User> us = new List <User>();
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
			insert r;
        for (integer i=0; i<5; i++){
            User usRec = new User (
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
     				LastName = 'last',
                	Email = 'puser000@amamama.com',
     				Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     				CompanyName = 'TEST',
     				Title = 'title',
     				Alias = 'alias',
     				TimeZoneSidKey = 'America/Los_Angeles',
     				EmailEncodingKey = 'UTF-8',
                	LanguageLocaleKey = 'en_US',
     				LocaleSidKey = 'en_US',
     				UserRoleId = r.Id
            		);
            us.add(usRec);
            
        }
        
        List <Contact> con = new List <Contact>();
        for (integer i=0; i<5; i++){
            
            Contact conRec = new Contact (
            	FirstName= 'Muhammad', LastName='Arham'
            );
            
            con.add(conRec);
        }
        Test.startTest();
        	insert us;
        	us[0].contactid = con[0].id;
        	insert con;
        	footerController.getManagerDetails(us[0].id);
        Test.stopTest();
    }
}