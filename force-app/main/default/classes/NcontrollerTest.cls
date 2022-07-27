@IsTest
public class NcontrollerTest {
     public static testMethod void NcontrollerTest () {
      List<Notification__c> Nclist = new List<Notification__c>();
         for(Integer i=0; i<10; i++) {
         Notification__c notif = new Notification__c(
          Name ='Test NC' + String.valueOf(i) , 
             Notification_Message__c = 'its me' ,Active__c = true ,Type__c ='HomePage Top Notification' );
             
             
             Nclist.add(notif);
             
             
             
             
             
             
    
         
         }
          insert Nclist;
         
         Test.startTest(); 
         NotificationController.getNotification();
         Test.stopTest();
     }
}