public class CaseTriggers 
{
    // Before insert / update method
    /*
    public static void updateCaseSendAutoResponse(List<Case> caseListNew, TriggerType tt)
    {
        // This code just sets the flag Send Auto Response Email to false on the case if the 
        // List of Email Auto Router records contains the Supplied Email
        // The actual re-routing is called from Case_Queueable after all of the other fields have been set
      	Set<String> suppliedEmail = new Set<String>();
        for(Case cs : caseListNew)
        {
            suppliedEmail.add(cs.SuppliedEmail);
        }
        
        // Check if the Supplied Email is in the Blacklist_Email__c object and if so, check the box so that the Workflow Rule does not fire off an auto-reply email alert
        List<Email_Auto_Router__c> autoRouteList = new List<Email_Auto_Router__c>([SELECT Id, Name FROM Email_Auto_Router__c WHERE Name IN :suppliedEmail]);
        Set<String> autoRouteEmails = new Set<String>();
        
        for(Email_Auto_Router__c ear : autoRouteList)
        {
            autoRouteEmails.add(ear.Name);
        }
        
        List<Case> casesToReroute = new List<Case>();
        for(Case cs : caseListNew)
        {
            if(autoRouteEmails.contains(cs.SuppliedEmail))
            {
                cs.Send_Auto_Response_Email__c = false;
            }
        }
    }
	*/
    
    // After Insert / Update method
	public static void updateCaseFields(List<Case> caseListNew, Map<Id, Case> caseMapOld, TriggerType tt)
    {
        if(tt == TriggerType.isInsert)
        {
            Set<Id> caseIds = new Set<Id>();
            for(Case cs : caseListNew)
            {
                caseIds.add(cs.Id);
            }
            
			Case_Queueable caseQueue = new Case_Queueable('updateCaseFields', caseIds, tt);
            System.enqueueJob(caseQueue);
        }
        else if(tt == TriggerType.isUpdate)
        {
            Set<Id> caseIds = new Set<Id>();
            for(Case cs : caseListNew)
            {
                if(String.valueOf(cs.OwnerId).left(3) == '00G'
                   && cs.OwnerId != caseMapOld.get(cs.Id).OwnerId)
                {
                	caseIds.add(cs.Id);
                }
            }
            
            if(!caseIds.isEmpty())
            {
				Case_Queueable caseQueue = new Case_Queueable('updateCaseFields', caseIds, tt);
            	System.enqueueJob(caseQueue);
            }
        }

        SystemUtilities.setExecuted('CaseTriggers.updateCaseFields');
    }
    
    // This is called from the Account_After trigger
    // We want to limit the number of possible Cases returned, hence the LAST_N_DAYS:5
    // This will match the Account's PersonEmail with the Case's SuppliedEmail.
    // If there is a match against a Case created in the last 5 days, the Case will be updated with 
    // this method. If not, the Case will need to be updated manually
   /* public static void updateCaseContact(List<Account> acctListNew)
    {
        List<Case> caseList = new List<Case>([SELECT Id, AccountId, ContactId, SuppliedEmail
                                               FROM Case 
                                              WHERE CreatedDate >= LAST_N_DAYS:5
                                                AND AccountId = null]);
        
        Map<String, List<Case>> suppliedEmailToCase = new Map<String, List<Case>>();
        for(Case cs : caseList)
        {
            if(cs.SuppliedEmail != null && cs.SuppliedEmail != '')
            {
                if(suppliedEmailToCase.containsKey(cs.SuppliedEmail))
                {
                    suppliedEmailToCase.get(cs.SuppliedEmail).add(cs);
                }
                else
                {
                    suppliedEmailToCase.put(cs.SuppliedEmail, new List<Case>{cs});
                }
            }
        }
        
        List<Case> caseListToUpdate = new List<Case>();
        for(Account acct : acctListNew)
        {
            if(suppliedEmailToCase.containsKey(acct.PersonEmail))
            {
                List<Case> csList = suppliedEmailToCase.get(acct.PersonEmail);
                for(Case cs : csList)
                {
                    cs.AccountId = acct.Id;
                    cs.ContactId = acct.PersonContactId;
                    
                    caseListToUpdate.add(cs);
                }
            }
        }
        
        if(!caseListToUpdate.isEmpty())
        {
            SystemUtilities.setExecuted('CaseTriggers.updateCaseContact');
            
            database.update(caseListToUpdate);
            
            SystemUtilities.resetExecuted('CaseTriggers.updateCaseContact');
        }
    } */
   /* 
    public static void updateCaseContact(List<Case> caseListNew, Map<Id, Case> caseMapOld, TriggerType tt)
    {
        SystemUtilities.getAllRecordTypes();
        
        if(tt == TriggerType.isInsert)
        {
            // Find any existing contacts based on the Email address
            Set<String> emails = new Set<String>();
            for(Case cs : caseListNew)
            {
                if(cs.SuppliedEmail != null)
                {
                    emails.add(cs.SuppliedEmail);
                }
            }
            
            if(emails.isEmpty()) return;
            
            // Get the queues
            SystemUtilities.getQueues();
            
            // Get the Queue to Channel mapping from the Custom Metadata Type
            Queue_Channel_Mapping__mdt[] queueToChannel = [SELECT MasterLabel, Channel__c FROM Queue_Channel_Mapping__mdt];
            
            Map<String, Queue_Channel_Mapping__mdt> queueToChannelMap = new Map<String, Queue_Channel_Mapping__mdt>();
            for(Queue_Channel_Mapping__mdt qcm : queueToChannel)
            {
                queueToChannelMap.put(qcm.MasterLabel, qcm);
            }
            
            // Existing Person Accounts
            List<Contact> existingContactList = new List<Contact>([SELECT Id, AccountId, FirstName, LastName, Phone, MobilePhone, 
                                                                          Email, Email2__c, Email3__c,Channel__c
                                                                     FROM Contact
                                                                    WHERE Email IN :emails
                                                                       OR (Email2__c != null AND Email2__c IN :emails)
                                                                       OR (Email3__c != null AND Email3__c IN :emails)
                                                                       ]);
            
            if(existingContactList.isEmpty()) return;
    
            // Key = Email + '|' + Channel_pc
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
                
              /*  if(contact.Email4__c != null  && !existingContactMap.containsKey(contact.Email4__c + '|' + contact.Channel__c))
                {
                    existingContactMap.put(contact.Email4__c + '|' + contact.Channel__c, contact);
                }
                
                if(contact.Email5__c != null && !existingContactMap.containsKey(contact.Email5__c + '|' + contact.Channel__c))
                {
                    existingContactMap.put(contact.Email5__c + '|' + contact.Channel__c, contact);
                }*/
        //    }
        
            // Loop through the Cases and New Contacts and associate the ID to the Case record matching on both the Email and the Queue - Account Channel
           /* for(Case cs : caseListNew)
            {
                System.debug('Logical Processes:');
                System.debug('Case Supplied Email and Site Name must be populated before attempting a match to an existing Contact');
                System.debug('Contact (Email OR Email2 OR Email3 OR Email4 OR Email5) AND Channel must be populated to match a Case to a Contact.');
                System.debug('Case Supplied Email: ' + cs.SuppliedEmail);
                System.debug('Case Site Name: ' + cs.Site_Name__c);
                
                if(SystemUtilities.queueMap.containsKey(cs.OwnerId))
                {
                    System.debug('Groups and Queues Contains Case OwnerId: ' + SystemUtilities.queueMap.containsKey(cs.OwnerId));
                    if(queueToChannelMap.containsKey(SystemUtilities.queueMap.get(cs.OwnerId).Name))
                    {
                        System.debug('First IF: ' + queueToChannelMap.containsKey(SystemUtilities.queueMap.get(cs.OwnerId).Name));
                        Queue_Channel_Mapping__mdt qcm = queueToChannelMap.get(SystemUtilities.queueMap.get(cs.OwnerId).Name);
                        
                        if(existingContactMap.containsKey(cs.SuppliedEmail + '|' + qcm.Channel__c))
                        {
                            System.debug('First IF Existing Contact Map Contains: ' + existingContactMap.containsKey(cs.SuppliedEmail + '|' + qcm.Channel__c));
                            cs.AccountId = existingContactMap.get(cs.SuppliedEmail + '|' + qcm.Channel__c).AccountId;
                            cs.ContactId = existingContactMap.get(cs.SuppliedEmail + '|' + qcm.Channel__c).Id;
                        }
                    }
                    else if(existingContactMap.containsKey(cs.SuppliedEmail + '|' + cs.Site_Name__c))
                    {
                        System.debug('Second IF: ' + existingContactMap.containsKey(cs.SuppliedEmail + '|' + cs.Site_Name__c));
                        cs.AccountId = existingContactMap.get(cs.SuppliedEmail + '|' + cs.Site_Name__c).AccountId;
                        cs.ContactId = existingContactMap.get(cs.SuppliedEmail + '|' + cs.Site_Name__c).Id;
                    }
                }
            }
        }
        else if(tt == TriggerType.isUpdate)
        {
            Set<Id> acctIds = new Set<Id>();
            Set<Id> contactIds = new Set<Id>();
            for(Case cs : caseListNew)
            {
                if(cs.AccountId != null 
                   && cs.AccountId != caseMapOld.get(cs.Id).AccountId)
                {
                    acctIds.add(cs.AccountId);
                    //contactIds.add(cs.ContactId);
                }
                
                if(cs.ContactId != null
                   && cs.ContactId != caseMapOld.get(cs.Id).ContactId)
                {
                    contactIds.add(cs.ContactId);
                }
            }
            
            System.debug(acctIds);
            System.debug(contactIds);
            
            if(!acctIds.isEmpty())
            {
                // If it is a person Account, then update the related Contact. Otherwise, bypass this logic for Business Accounts
                Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id, PersonContactId, RecordTypeId,
                                                                   (SELECT Id, AccountId FROM Contacts)
                                                                   FROM Account 
                                                                  WHERE Id IN :acctIds]);
				
                for(Case cs : caseListNew)
                {
                    if(acctMap.containsKey(cs.AccountId))
                    {
                        Account acct = acctMap.get(cs.AccountId);
                        System.debug(acct);
                        
                        if(SystemUtilities.recordTypeMap.get(acct.RecordTypeId).DeveloperName == 'PersonAccount')
                        {
                        	cs.ContactId = acctMap.get(cs.AccountId).PersonContactId;
                        }
                        else
                        {
                            // Wipe the Contact field if the Account has changed and the Contact Account Id does not match
                            Boolean contactMatch = false;
                            for(Contact cont : acct.Contacts)
                            {
                                System.debug('Line 248: ' + cont.AccountId);
                                if(cs.ContactId == cont.Id)
                                {
                                    contactMatch = true;
                                }
                            }
                            
                            if(contactMatch == false)
                            {
                                cs.ContactId = null;
                            }
                        }
                    }
                }
            }
            
            if(!contactIds.isEmpty())
            {
                Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, AccountId
                                                                          FROM Contact
                                                                         WHERE Id IN :contactIds]);
                
                for(Case cs : caseListNew)
                {
                    if(cs.ContactId != null && contactMap.containsKey(cs.ContactId))
                    {
                        Contact cont = contactMap.get(cs.ContactId);
                        
                        if(cont.AccountId != cs.AccountId) 
                        {
                        	cs.AccountId = cont.AccountId;
                        }
                    }
                }
            }
        }
    }
    
    */
    public static void copyWebToCaseMessageAndName(List<Case> caseListNew)
    {
        for(Case cs : caseListNew)
        {
            if(cs.Origin == 'Web to Case')
            {
                //String webToCsMsg = cs.Web_to_Case_Message__c;
                cs.Description = cs.Form_Message__c;
                cs.SuppliedName = cs.First_Name__c + ' ' + cs.Last_Name__c;
            }
        }
    }
    
    
  /*  public static void updateAutoCloseDate(List<Case> caseListNew, Map<Id, Case> caseMapOld, TriggerType tt)
    {
        Case_Auto_Close_Date__mdt[] autoCloseDays = [SELECT Auto_Close_After_Days__c FROM Case_Auto_Close_Date__mdt LIMIT 1];
        
        for(Case cs : caseListNew)
        {
            // We don't want to reset the Auto-Close Date on just any update. 
            // Only if the Status has changed to 'Waiting for Customer Response'
            if(cs.Sub_Status__c == 'Open: Need Customer reply'
              && cs.Sub_Status__c != caseMapOld.get(cs.Id).Sub_Status__c)
            {
                cs.Auto_Close_Date__c = Date.today() + (Integer)autoCloseDays[0].Auto_Close_After_Days__c;
            }
            else if(cs.Status != 'Closed' && cs.Sub_Status__c != 'Open: Need Customer reply')
            {
                cs.Auto_Close_Date__c = null;
                cs.Auto_Closed__c = false;
            }
        }
    } */
    
    /*
    public static void reassociateToOpenCase(List<Case> caseListNew, TriggerType tt)
    {
        SystemUtilities.getQueues();
        
        Set<String> fromEmailAddress = new Set<String>();
        for(Case cs : caseListNew)
        {
            fromEmailAddress.Add(cs.SuppliedEmail);
        }
        
        // We need the Original Queue name in the case an agent took ownership of a case and it is in their name
        List<Case> openCaseList = new List<Case>([SELECT Id, SuppliedEmail, CreatedDate, OwnerId, Original_Queue__c
                                                    FROM Case 
                                                   WHERE SuppliedEmail IN :fromEmailAddress
                                                     AND IsClosed = false]);

        if(openCaseList.isEmpty()) return;
        
        Map<String, Case> openCaseMap = new Map<String, Case>();
        
        for(Case openCase : openCaseList)
        {
            String key = '';
            
            if(String.valueOf(openCase.OwnerId).left(3) == '00G' &&
               SystemUtilities.queueMap.containsKey(openCase.OwnerId))
            {
                key = SystemUtilities.queueMap.get(openCase.OwnerId).Name + '_' + openCase.SuppliedEmail;
            }
            else if(openCase.Original_Queue__c != '')
            {
                key = openCase.Original_Queue__c + '_' + openCase.SuppliedEmail;
            }
            
            if(key != '' 
               && openCaseMap.ContainsKey(key)
               && openCaseMap.get(key).CreatedDate > openCase.CreatedDate)
            {
                openCaseMap.put(key, openCase);
            }
            else if(key != '' && !openCaseMap.ContainsKey(key))
            {
                openCaseMap.put(key, openCase);
            }
        }
        
        // Find the earliest open case using the Key: Queue Name + '_' + SuppliedEmail. 
        // We should only have 1 email to 1 open case (if one exists), and it should be the oldest
        
        // Now loop through the incoming new cases and update the Parent Case Id with the pre-existing ones if any exist
        for(Case cs : caseListNew)
        {
            if(SystemUtilities.queueMap.containsKey(cs.OwnerId))
            {
                String key = SystemUtilities.queueMap.get(cs.OwnerId).Name + '_' + cs.SuppliedEmail;
                
                if(openCaseMap.ContainsKey(key)) 
                {
                    cs.ParentId = openCaseMap.get(key).Id;
                }
            }
        }
    }
	*/

}