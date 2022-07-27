public class NotificationController {
	
    @AuraEnabled
    public static String getNotification(){
        List<Notification__c> notificationList = new List<Notification__c>();
        String userLanguage = UserInfo.getLanguage();
        notificationList = [select id, Notification_Message__c, Active__c, Notification_Message_de__c, Notification_Message_fr__c from Notification__c where Active__c = true and Type__c ='HomePage Top Notification'];
        system.debug('notificationList'+notificationList);
        system.debug('userLanguage'+userLanguage);
        
        if(notificationList.size() > 0){
            if(userLanguage == 'en'){
                return notificationList[0].Notification_Message__c;
            } else if(userLanguage == 'de'){
                return notificationList[0].Notification_Message_de__c;  
            } else if(userLanguage == 'fr'){
                return notificationList[0].Notification_Message_fr__c;  
            } else {
                return notificationList[0].Notification_Message__c; 
            }
        } else {
            return '';
        }
    }
    
}