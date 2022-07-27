public class DynamicContentCtrl 
{
    @AuraEnabled
    public static Object getDynamicContentHeader(String contentName)
    {
        Dynamic_Content__c dynContent = [select Id, Heading__c, Sub_Heading_1__c, Sub_Text_1__c from Dynamic_Content__c where Content_Name__c = :contentName];
        return dynContent;
    }
    
    @AuraEnabled
    public static List<Object> getContentSection(String contentName)
    {
        List<Content_Section__c> lstContentSection = [select Text_1__c, Button_Label_1__c, Order__c, Rich_Text_1__c
                                                      from Content_Section__c 
                                                      where Dynamic_Content__r.Content_Name__c = :contentName order by Order__c];
        
        return lstContentSection;
    }
    
}