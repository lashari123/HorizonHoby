public class SavedFilterListController {
	@AuraEnabled
    public static List<Filter_List__c> getSavedFilterList(){        
        List<Filter_List__c> savedFilterList = new List<Filter_List__c>();
        savedFilterList = [SELECT Id, User_Id__c, Name, Attribute_List__c FROM Filter_List__c WHERE User_Id__c =: Userinfo.getUserid()];
        
        return savedFilterList;
    }
    
    @AuraEnabled
    public static void deleteSavedFilterList(String filterId){        
        List<Filter_List__c> deleteFilterList = new List<Filter_List__c>();
        deleteFilterList = [SELECT Id, User_Id__c, Name, Attribute_List__c FROM Filter_List__c WHERE Id =: filterId];
        
        delete deleteFilterList;
    }
    
    @AuraEnabled
    public static List<Filter_List__c> GetSelectedFilterList(String filterId){        
        List<Filter_List__c> filterList = new List<Filter_List__c>();
        filterList = [SELECT Id, User_Id__c, Name, Attribute_List__c FROM Filter_List__c WHERE Id =: filterId];
        
        return filterList;
    }
}