public without sharing class footerController {
    @auraEnabled
    public static user getManagerDetails(string uId){

        string contactId = [Select id, contactid, contact.MobilePhone from User where id = :uid limit 1]?.contactid;
        
        contact con = [Select id,account.manager__c,WeekEndTiming__c,WeekDayTiming__c from contact where id = :contactID limit 1];
        if(con!= null){
            if(con.account.manager__c != null){
                string managerID = con.account.manager__c;
                user manager = [SELECT Id, firstName,lastName, Username, CompanyName, Email, Phone, MobilePhone   FROM User where id =: managerID];
                manager.Contact = new contact();
                manager.contact.WeekEndTiming__c = con.WeekEndTiming__c;
                manager.contact.WeekDayTiming__c= con.WeekDayTiming__c;
                return manager;
            }
        }
        return new user(contactid =contactId );
    }
}