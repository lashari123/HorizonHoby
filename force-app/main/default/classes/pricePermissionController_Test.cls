@isTest
public class pricePermissionController_Test {
    public static testMethod void pricePermissionMethod (){

            UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
			insert r;
	String ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
     
     User u = new User(
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
     UserRoleId = r.Id,
     ProfileId = ProfileId
            );
        
        Insert u;
        PricePermisionController.givePermission(u.id);
        PricePermisionController.deletePermission(u.id);
        PricePermisionController.isPermissionAssigned(u.id);
        
    }
}