@isTest
public class SystemUtilities_Test 
{
	@isTest
    static void testSetResetExecuted()
    {
        SystemUtilities.setExecuted('testMethod');
        SystemUtilities.resetExecuted('testMethod');
        
        Systemutilities.isAlreadyExecuted('testMethod');
        
        SystemUtilities.setExecuted('testMethod');
        SystemUtilities.resetAllExecuted();
    }
    
    @isTest
    static void testGetUserInfo()
    {
        Set<Id> userIds = new Set<Id>();
        User u = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];
        SystemUtilities.getUserInfo(new Set<Id>{u.Id});
        userIds.add(u.Id);
        
        User u2 = [SELECT Id FROM User WHERE IsActive = TRUE AND Id NOT IN :userIds LIMIT 1];
        SystemUtilities.getUserInfo(new Set<Id>{u2.Id});
    }
}