@isTest
global class NotificationController_test {
    
 global static testmethod void getNotification(){
        
        list<Notification__c> notiList = new list <Notification__c>();        
        Notification__c noti = new Notification__c();
        noti.Language__c = 'en_US';
        noti.Notification_Message__c = '' ;
        noti.Active__c=True;
        noti.Type__c='HomePage Top Notification';
        notiList.add(noti);
        insert notiList;
        
     		Profile p = [select id from profile where name='Standard User'];
        List<User> getUser = new List<User>();

        User u = new User(
						  
                           LastName = 'LIVESTON',
                           FirstName ='JASON',
                           Username  = 'jason.liveston@naja.com',
                           CompanyName = 'Jasonprivatelimited',
                           Email = 'jason.liveston@asdf.com',
            	   	   		Alias = 'jasonAA',
            		   		TimeZoneSidKey = 'GMT',
            		   		LocaleSidKey = 'en_US', 
                           EmailEncodingKey = 'UTF-8', 
                           LanguageLocaleKey = 'en_US',
                           Phone = '+2121212',
                           MobilePhone = '+213123',
                           ProfileId = P.id
                 );
        getUser.add(u);
        insert getUser;
    	 System.runAs(u) {
            
                  NotificationController.getNotification();

          } 
     
     
        list<Notification__c> notiList1 = new list <Notification__c>();        
        Notification__c noti1 = new Notification__c();
        noti.Language__c = 'de';
        noti.Notification_Message_de__c = 'de';
        noti.Active__c=True;
        noti.Type__c='HomePage Top Notification';
        notiList1.add(noti1);
        insert notiList1;
         
         
        Profile p1 = [select id from profile where name='Standard User'];
        List<User> getUser1 = new List<User>();

        User u1 = new User(
						  
                           LastName = 'LIVESTON',
                           FirstName ='JASON',
                           Username  = 'jason.liveston@najam.com',
                           CompanyName = 'Jasonprivatelimited',
                           Email = 'jason.liveston@asdf.com',
            	   	   		Alias = 'jasonAA',
            		   		TimeZoneSidKey = 'GMT',
            		   		LocaleSidKey = 'de', 
                           EmailEncodingKey = 'UTF-8', 
                           LanguageLocaleKey = 'de',
                           Phone = '+2121212',
                           MobilePhone = '+213123',
                           ProfileId = P.id
                 );
        getUser1.add(u1);
        insert getUser1;
    	 System.runAs(u1) {
            
                  NotificationController.getNotification();

          }
       
      list<Notification__c> notiList2 = new list <Notification__c>();        
        Notification__c noti2 = new Notification__c();
        noti.Language__c = 'fr';
        noti.Notification_Message_fr__c = 'fr';
        noti.Active__c=True;
        noti.Type__c='HomePage Top Notification';
        notiList2.add(noti2);
        insert notiList2;
         
         
        Profile p2 = [select id from profile where name='Standard User'];
        List<User> getUser2 = new List<User>();

        User u2 = new User(
						  
                           LastName = 'LIVESTON',
                           FirstName ='JASON',
                           Username  = 'jason.liveston@najamm.com',
                           CompanyName = 'Jasonprivatelimited',
                           Email = 'jason.liveston@asdf.com',
            	   	   		Alias = 'jasonAA',
            		   		TimeZoneSidKey = 'GMT',
            		   		LocaleSidKey = 'fr', 
                           EmailEncodingKey = 'UTF-8', 
                           LanguageLocaleKey = 'fr',
                           Phone = '+2121212',
                           MobilePhone = '+213123',
                           ProfileId = P.id
                 );
        getUser2.add(u2);
        insert getUser2;
    	 System.runAs(u2) {
            
                  NotificationController.getNotification();

          }
     
          }
}