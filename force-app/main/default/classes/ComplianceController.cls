public class ComplianceController {
	@AuraEnabled
    public static String getCompliance(){
        List<Notification__c> fp = new List<Notification__c>();
        fp = [SELECT Id FROM Notification__c where Type__c ='Compliance'];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
		cdl = [SELECT Id, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: fp[0].Id];
        
        ContentVersion cv = new ContentVersion();
        cv = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = :cdl.ContentDocumentId AND IsLatest = true];
        String returnValue = cv.VersionData.toString();
        
        return returnValue;
    }
}