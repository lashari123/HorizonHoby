@isTest
public class TestDataFactory {
    public static List<Account> createPersonAccount(Integer num, String email)
    {
        Id rtId = schema.SObjectType.account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        List<Account> testPersonAccountList = new List<Account>();
        for(Integer i=0; i<num; i++)
        {
            Account persAcct = new Account();
            persAcct.FirstName = 'TestFirst' + String.valueOf(i);
            persAcct.LastName = 'TestLast' + String.valueOf(i);
            persAcct.PersonEmail = email + String.valueOf(i) + '@horizonhobby.com';
            persAcct.RecordTypeId = rtId;            
            testPersonAccountList.add(persAcct);
        }
        return testPersonAccountList;
    }
   
    public static List<Case> createTestEmailToCase(Integer num, String email)
    {
        List<Case> testCaseList = new List<Case>();
        Group que = [SELECT Id FROM Group WHERE Type = 'Queue' and Name ='HH Consumer Sales'];
        for(Integer i=0; i<num; i++){
            Case cs = new Case();
            cs.SuppliedPhone = '555-123-4567';
            cs.Order_Number__c = '';
            cs.Subject = 'Test Case Subject';
            cs.Description = 'Test Case Description';
            cs.Status = 'New';
            cs.Site_Name__c ='horizon-us';
            cs.ownerId =que.id;
         //   cs.SuppliedName = 'TestFirst' + String.valueOf(i) + ' TestLast' + String.valueOf(i);
            cs.SuppliedEmail = email + String.valueOf(i) + '@horizonhobby.com';

             testCaseList.add(cs);
        }
        
        return testCaseList;
        
    }
    public static List<Case> createTestSiteNameCase(Integer num, String email)
    {
        List<Case> testCaseList = new List<Case>();
        Group que = [SELECT Id FROM Group WHERE Type = 'Queue' and Name ='Wholesale'];
        for(Integer i=0; i<num; i++){
            Case cs = new Case();
            cs.SuppliedPhone = '555-123-4567';
            cs.Order_Number__c = '';
            cs.Subject = 'Test Case Subject';
            cs.Description = 'Test Case Description';
            cs.Status = 'New';
            cs.Site_Name__c ='horizon-us';
            cs.ownerId =que.id;
         //   cs.SuppliedName = 'TestFirst' + String.valueOf(i) + ' TestLast' + String.valueOf(i);
            cs.SuppliedEmail = email + String.valueOf(i) + '@horizonhobby.com';

             testCaseList.add(cs);
        }
        
        return testCaseList;
}
    
    Public static List<EmailMessage> createEmailTest(Integer num){
        
        List<EmailMessage> EmailMsg = new List<EmailMessage>();
        for(Integer i=0; i<num; i++){
            EmailMessage em1 = new EmailMessage() ;
            em1.FromAddress ='abc0@horizonhobby.com';
            em1.ToAddress = 'customersupport@horizonhobby.com';
            //em1.ParentId = cs.Id;
            em1.Subject = 'Test inbound customer email';
            em1.TextBody = 'Test inbound customer email';
           EmailMsg.add(em1);
            
    }
         return EmailMsg;
}
     Public static List<EmailMessage> createEmailBodyQuestionTest(Integer num){
        
        List<EmailMessage> EmailMsg = new List<EmailMessage>();
        for(Integer i=0; i<num; i++){
            EmailMessage em1 = new EmailMessage() ;
            em1.FromAddress ='abc0@horizonhobby.com';
            em1.ToAddress = 'customersupport@horizonhobby.com';
            //em1.ParentId = cs.Id;
            em1.Subject = 'Test inbound customer email';
            em1.TextBody = 'Hello How are you ?';
           EmailMsg.add(em1);
            
    }
         return EmailMsg;
}
    Public static List<EmailMessage> createEmailBodyLengthTest(Integer num){
        
        List<EmailMessage> EmailMsg = new List<EmailMessage>();
        for(Integer i=0; i<num; i++){
            EmailMessage em1 = new EmailMessage() ;
            em1.FromAddress ='abc0@horizonhobby.com';
            em1.ToAddress = 'customersupport@horizonhobby.com';
            //em1.ParentId = cs.Id;
            em1.Subject = 'Test inbound customer email';
            em1.TextBody = 'Hello How are you ? Hello How are you ? Hello How are you ? Hello How are you ? Hello How are you ? Hello How are you ?';
           EmailMsg.add(em1);
            
    }
         return EmailMsg;
}
     public static List<Case> createCaseFromContact(List<Account> persAcctList, Id ownerId)
    {
        List<Case> testCaseList = new List<Case>();
        
        for(Account a : persAcctList)
        {
            Case cs = new Case();
            cs.AccountId = a.Id;

            cs.Subject = 'Test Case Subject';
            cs.Description = 'Test Case Description';
            cs.Status = 'New';
            cs.Sub_Status__c = '';
            cs.Site_Name__c = 'horizon-us';
            
            cs.OwnerId = ownerId;
            
            
            testCaseList.add(cs);
        }
        
        return testCaseList;
    }
    
    //Chat to Case
    public static List<Case> createChatToCase(String QueueName,String Origin,List<String> Channel, List<String>  Reason)
    {
        List<Case> testCaseList = new List<Case>();
        Group que = [SELECT Id FROM Group WHERE Type = 'Queue' and Name =: QueueName];
      for(Integer i=0; i<Channel.size(); i++){
            Case cs = new Case();
            cs.SuppliedPhone = '555-123-4567';
            cs.Order_Number__c = '';
            cs.Subject = 'Test Case Subject';
            cs.Description = 'Test Case Description';
            cs.Status = 'New';
            cs.Site_Name__c ='horizon-us';
          //  cs.ownerId =que.id;
            cs.Origin=Origin;
            cs.Channel__c=Channel[i];
            cs.Reason=Reason[i];
           

             testCaseList.add(cs);
      }
        
        return testCaseList;
        
    }
    
    
    public static void createWebToCase(String Origin,String Reason,String Channel)
    {
         Case cs = new Case();
            cs.SuppliedPhone = '555-123-4567';
            cs.Order_Number__c = '';
            cs.Subject = 'Test Case Subject';
            cs.Description = 'Test Case Description';
            cs.Status = 'New';
            cs.Site_Name__c ='horizon-us';
            cs.Reason=Reason;
            cs.Channel__c=Channel;
            cs.SuppliedEmail='xyz0@horizonhobby.com';
            cs.Origin=Origin;
            insert cs;
        
    }
}