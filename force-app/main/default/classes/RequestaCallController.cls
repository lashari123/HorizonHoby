public without sharing class RequestaCallController {
    @auraEnabled(Cacheable=true)
    public static User getContactNumber(){
        return [Select id , contact.MobilePhone from User where id =:Userinfo.getUserId() ];
    }
    
    @auraEnabled
    public static void createTask(string subject, string Message, string ContactNumber,string contactId){
        system.debug(subject +' '+ message+' '+contactNumber+' '+contactID);
        
        contact con = [Select id , account.Manager__c from contact where ID= :contactID ];
        
        Task tsk = new Task();
        
        tsk.subject = subject;
        tsk.whoId = contactId;
        tsk.Description = message;
        tsk.OwnerId = con.account.Manager__c;//'0054V00000F3UvXQAV';
        
        tsk.contact_Number__c = contactNumber;
        
        insert tsk;
        
    }
}