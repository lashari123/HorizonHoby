public with sharing class PricePermisionController {
    @AuraEnabled
    public static boolean givePermission(string myAssigneeId){
        system.debug(myAssigneeId);
      /*  string myPermissionSetId = [SELECT Id, Name, Label, LicenseId, ProfileId FROM PermissionSet where name = 'Enable_List_Price']?.id;
        PermissionSetAssignment psa = new PermissionSetAssignment
            (PermissionSetId = myPermissionSetId, AssigneeId = myAssigneeId);*/
        User u = new user(id = myAssigneeId, is_Price__c = true);
        update u;   
        return true;
    }
    @AuraEnabled
    public static boolean deletePermission(string myAssigneeId){
        system.debug(myAssigneeId);
        
       // PermissionSetAssignment psa = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment where PermissionSet.Name = 'Enable_list_price' and AssigneeId = :myAssigneeId limit 1];
        User u = new user(id = myAssigneeId, is_Price__c = false);
        update u;  
        
        return false;
    }
    @AuraEnabled
    public static boolean isPermissionAssigned(string myAssigneeId){
        system.debug(myAssigneeId);
        
     //   PermissionSetAssignment psa = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment where PermissionSet.Name = 'Enable_list_price' and AssigneeId = :myAssigneeId limit 1];
		user u = [select id ,is_price__c from user where id = :myAssigneeId];
        return u.is_price__c;     
    }
}