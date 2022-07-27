public class HHFilterHelper {
    public static HH_Filter__c[] getAllFilter(){
           return [SELECT ID,Name,Query_String__c,parsingString__c from HH_Filter__c];
    }
    
     public static HH_Filter__c[] getMenuFilter(){
           return [SELECT ID,Name,Query_String__c,parsingString__c from HH_Filter__c where Showinmenu__c = true order by isEditable__c DESC];
    }
    
    public static HH_Filter__c getFilter(string HHFid){
           return [SELECT ID,Name,Query_String__c,parsingString__c,iseditable__c from HH_Filter__c where id =:HHFid limit 1];
    }
    
    public static HH_Filter__c getFilterbyName(string name){
        return [SELECT ID,Name,Query_String__c,parsingString__c,iseditable__c from HH_Filter__c where name =:name limit 1];
    }
}