public class CaseTriggerHelper {
    
    public static void AssociateCaseContact(List<Case> caseListNew)
    {
        if(Trigger.isUpdate)
        {
            try{
            Set<String> emails = new Set<String>();
            for(Case cs : caseListNew)
            {
                if(cs.SuppliedEmail != null && cs.Channel__c!=NULL)
                {
                    emails.add(cs.SuppliedEmail);
                }
            }
            
            // Find any existing contacts based on the Email address
            List<Contact> existingContactList = new List<Contact>([SELECT Id, AccountId,  
                                                                   Email, Email2__c, Email3__c,Channel__c
                                                                   FROM Contact
                                                                   WHERE Email IN :emails
                                                                   OR (Email2__c != null AND Email2__c IN :emails)
                                                                   OR (Email3__c != null AND Email3__c IN :emails)]);
            // Get the queues
            SystemUtilities.getQueues();
            Map<String, Contact> existingContactMap = new Map<String, Contact>();
            for(Contact contact : existingContactList)
            {
                if(contact.Email != null && !existingContactMap.containsKey(contact.Email + '|' + contact.Channel__c))
                {
                    existingContactMap.put(contact.Email + '|' + contact.Channel__c, contact);
                }
                if(contact.Email2__c != null && !existingContactMap.containsKey(contact.Email2__c + '|' + contact.Channel__c))
                {
                    existingContactMap.put(contact.Email2__c + '|' + contact.Channel__c, contact);
                }
                if(contact.Email3__c != null && !existingContactMap.containsKey(contact.Email3__c + '|' + contact.Channel__c))
                {
                    existingContactMap.put(contact.Email3__c + '|' + contact.Channel__c, contact);
                }
            }
            
            // Loop through the Cases and New Contacts and associate the ID to the Case record matching on both the Email and the Queue - Account Channel
            for(Case cs : caseListNew)
            {
                //Added newly
                if((existingContactMap.containsKey(cs.SuppliedEmail + '|' + cs.Channel__c))&&
                   (SystemUtilities.queueMap.get(cs.OwnerId).Name!='Email SPAM')&&(cs.Origin=='Web to Case'||cs.Origin=='Email to Case'))              
                    {
                        cs.ContactId = existingContactMap.get(cs.SuppliedEmail + '|' + cs.Channel__c).Id;
            	  	}
        	    }
            }catch (Exception ex) {
      		ExceptionLogger.LogException(ex);
    		}
        }
  }
    
    
    public static void SettingDefaultValues(List<Case> caseListNew){
       
        for(Case cs: caseListNew){
            if(Trigger.isInsert && Trigger.isBefore)
            {
                
                if(cs.Origin=='Email to Case'){
                    cs.Is_new__c=True;
                }
                
            }
            
            if(Trigger.isInsert && Trigger.isBefore)
             {
                 SetPurchasedMethodandSubOriginForWebtoCase(Trigger.new);
             }
            
            
        }


        //Method for setting the department and Subject
        if(Trigger.isUpdate && Trigger.isBefore)
        {	
            //For the setting the values on the Chat to Case
            CaseTriggerHelper.SetDepartmentAndSubjectForChatToCase(caseListNew);
            
            //For setting the values on the Phone Case
            CaseTriggerHelper.SetDepartmentForPhoneOrigin(caseListNew);
        }
        
    }
    public static void SetDepartmentAndSubjectForChatToCase(List < Case > caseListNew) {
     
      for (Case caseObj: caseListNew) {
      //Creating it for setting the department and Subject
   
    if (caseObj.Origin != NULL && caseObj.Origin == 'Chat to Case' && caseObj.IS_Chat_New__c == false) {

      //Department Product Support 
      if ((caseObj.Channel__c == 'horizon-us' && (caseObj.Reason == 'Technical Product Support' || caseObj.Reason == 'Repair Status') || caseObj.Reason == 'Technical Pre-Sales') ||
        (caseObj.Channel__c == 'tower-us' && (caseObj.Reason == 'Technical Pre-Sales' || caseObj.Reason == 'Technical Product Support'))) {
        caseObj.Subject = 'Product Support';
        caseObj.department__c = 'Product Support';
        caseObj.IS_Chat_New__c = true;
      }

      //Department Tech Support EU
      else if (caseObj.Channel__c != NULL && caseObj.Channel__c == 'horizon-eu' &&
        (caseObj.EU_Case_Reason__c == 'Repair Status' || caseObj.EU_Case_Reason__c == 'Technical Product Support')) {

        caseObj.department__c = 'Tech Support EU';
        caseObj.Subject = 'Tech Support EU';
        caseObj.IS_Chat_New__c = true;
      }
      //Department D2C Sales
      else if ((caseObj.Channel__c == 'tower-us' && (caseObj.Reason == 'Place an Order' || caseObj.Reason == 'Technical Pre-Sales')) ||
        (caseObj.Channel__c == 'horizon-us' && caseObj.Reason == 'Place an Order')) {
        caseObj.Subject = 'D2C Sales';
        caseObj.department__c = 'D2C Sales';
        caseObj.IS_Chat_New__c = true;
      }
      //Department Customer Service
      else if ((caseObj.Channel__c == 'horizon-us' || caseObj.Channel__c == 'tower-us') &&
        (caseObj.Reason == 'My Account / Club Question' ||
          caseObj.Reason == 'Easy Pay or Payment Question' ||
          caseObj.Reason == 'Order Status' ||
          caseObj.Reason == 'Customers outside the US / Canada' ||
          caseObj.Reason == 'Return Request' ||
          caseObj.Reason == 'Change / Cancel Order' ||
          caseObj.Reason == 'Another issue')

      )

      {

        caseObj.department__c = 'Customer Service';
        caseObj.Subject = 'Customer Service';
        caseObj.IS_Chat_New__c = true;
      }

      //Department Sales EU 
      else if (caseObj.Channel__c != NULL && caseObj.Channel__c == 'horizon-eu' &&
        (caseObj.EU_Case_Reason__c == 'Order Status' || caseObj.EU_Case_Reason__c == 'Return Request' ||
          caseObj.EU_Case_Reason__c == 'Another issue' || caseObj.EU_Case_Reason__c == 'Payment Question')) {

        caseObj.department__c = 'Sales EU';
        caseObj.Subject = 'Sales EU';
        caseObj.IS_Chat_New__c = true;
      }

    }
  }
 
}
    
     
 public static void SetDepartmentForPhoneOrigin(List < Case > caseListNew){
        
        for (Case caseObj: caseListNew) {
            
           if (caseObj.Origin != NULL && caseObj.Origin == 'Phone' && caseObj.IS_Chat_New__c == false) {
                
                //Update Department Customer service
                if (caseObj.Owner_Role__c  == 'Customer Service Supervisor' || caseObj.Owner_Role__c  == 'L1 CS'  || caseObj.Owner_Role__c  =='Specialty Services Supervisor'
                    || caseObj.Owner_Role__c  =='L2 (Digital) CS' ||  caseObj.Owner_Role__c  =='3P CS'  || caseObj.Owner_Role__c  =='WH CS'
                    || caseObj.Owner_Role__c  =='Social Service'){
                        caseObj.Department__c = 'Customer Service';
                        caseObj.IS_Chat_New__c = true;
                        
                    }
                
                //Update Department D2C
                else if (caseObj.Owner_Role__c  == 'D2C Sales Supervisor' || caseObj.Owner_Role__c  == 'L1 D2C Sales' 
                         || caseObj.Owner_Role__c  =='L2 (Digital) Sales'){
                             caseObj.Department__c = 'D2C Sales';
                             caseObj.IS_Chat_New__c = true;
                             
                         }
                
                
                //Update Department Product Support
                else if (caseObj.Owner_Role__c  == 'Product Support' || caseObj.Owner_Role__c  == 'L1 PS Supervisor'  || caseObj.Owner_Role__c  == 'L1 PS'  
                         || caseObj.Owner_Role__c  =='Elevation PS Supervisor' || caseObj.Owner_Role__c  =='L2 (Digital) PS'
                         || caseObj.Owner_Role__c  =='L3 PS'){
                             caseObj.Department__c = 'Product Support';
                             caseObj.IS_Chat_New__c = true;
                             
                         }
                
                //Update Department Service Center
                else if (caseObj.Owner_Role__c  == 'Service Center US' || caseObj.Owner_Role__c  == 'Service Center Repair'  
                         || caseObj.Owner_Role__c  =='Electronics Repair' || caseObj.Owner_Role__c  =='Engine Repair' 
                         || caseObj.Owner_Role__c  =='Product Repair'  || caseObj.Owner_Role__c  =='Service Center Ops' 
                         || caseObj.Owner_Role__c  == 'Train Repair'){
                             caseObj.Department__c = 'Service Center';
                             caseObj.IS_Chat_New__c = true;
                             
                         }
                
                //Update Wholesale Sales
                else if (caseObj.Owner_Role__c  == 'Wholesale Sales'){
                    caseObj.Department__c = 'Wholesale Sales';
                    caseObj.IS_Chat_New__c = true;
                    
                }
                //Update Sales EU
                else if (caseObj.Owner_Role__c  == 'EU Service' || caseObj.Owner_Role__c  == 'Sales EU'){
                    caseObj.Department__c = 'Sales EU';
                    caseObj.IS_Chat_New__c = true;
                    
                }
                
                
                //Update  Tech Suppports
                else if (caseObj.Owner_Role__c  == 'Tech Support EU'){
                    caseObj.Department__c = 'Tech Support EU';
                    caseObj.IS_Chat_New__c = true;
                    
                }
                
            }
        }
   }
    
    
    public static void SetPurchasedMethodandSubOriginForWebtoCase(List < Case > caseListNew){
        
        for (Case caseObj: caseListNew) {
            
            
            if (caseObj.Origin != NULL && caseObj.Origin == 'Web to Case') {
                
                
                if(caseObj.Reason=='My Account or RC Club question' || caseObj.Reason=='My Account or Club question'){
                    
                    caseObj.Reason='My Account / Club Question';
                }
                
                //Check Channel Horizon US 
                if (caseObj.Channel__c == 'horizon-us'){
                    caseObj.Purchase_Method__c = 'HH-US D2C Direct';
                    caseObj.Case_Sub_origin__c = 'HH Site';
                }
                
                //Check Tower US 
                if (caseObj.Channel__c == 'tower-us'){
                    caseObj.Purchase_Method__c = 'TH-US D2C Direct';
                    caseObj.Case_Sub_origin__c = 'TH Site';
                }
                
                //Check Horizon EU 
                if (caseObj.Channel__c == 'horizon-eu'){
                    caseObj.Purchase_Method__c = 'HH-EU Direct';
                    caseObj.Case_Sub_origin__c = 'EU Site';
               }
           }
        }
    }
 
    
}