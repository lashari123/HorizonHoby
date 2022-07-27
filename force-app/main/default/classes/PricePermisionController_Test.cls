@isTest
public class PricePermisionController_Test {

    static testMethod void PricePermision(){
       
       Profile p = [SELECT Id FROM Profile WHERE Name='myAssigneeId'];
        List<User> getUser = new List<User>();
        User myAssigneeId = new User(
            id = 'myAssigneeId',
            is_price__c = True        
        );
            
    }
}