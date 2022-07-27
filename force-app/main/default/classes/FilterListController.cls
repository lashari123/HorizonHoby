public class FilterListController {
	@AuraEnabled
    public static String CreateFilterList(String attributeList, String Name){
        Filter_List__c filterList = new Filter_List__c();
        filterList.User_Id__c = Userinfo.getUserid();
        filterList.Attribute_List__c = attributeList;
        filterList.Name = Name;
        
        insert filterList;
        
        return 'Success';
    }
    
    @AuraEnabled
    public static String UpdateFilterList(String attributeList, String Name, String Id){
        Filter_List__c filterList = new Filter_List__c();
        filterList.Id = Id;
        filterList.Attribute_List__c = attributeList;
        filterList.Name = Name;
        
        update filterList;
        
        return 'Success';
    }
}