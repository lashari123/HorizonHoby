public class Case_Queueable implements Queueable
{
	public String process;
    public Set<Id> caseIds;
    public TriggerType tt;
    
    public Case_Queueable(){}
    
    public Case_Queueable(String process, Set<Id> caseIds, TriggerType tt)
    {
        this.process = process;
        this.caseIds = caseIds;
        this.tt = tt;
    }
    
	public void execute(QueueableContext context) 
    {
        if(process == 'updateCaseFields')
        {
            // Get the cases in context
            List<Case> caseListNew = new List<Case>();
            caseListNew = SystemUtilities.caseQuery(caseIds);
            
            if(caseListNew.isEmpty()) return;

            SystemUtilities.getQueues();
            
            List<EmailMessage> emailMessages;
            // Get the inbound emails related to the case. We need to retrieve the TO Address
            if(Test.isRunningTest())
            {
    	        emailMessages = new List<EmailMessage>([SELECT Id, ParentId, FromAddress, CreatedDate
                                                          FROM EmailMessage]);                
            }
            else
            {
    	        emailMessages = new List<EmailMessage>([SELECT Id, ParentId, FromAddress, CreatedDate
                                                          FROM EmailMessage
                                                         WHERE Incoming = true
                                                           AND ParentId IN :caseIds]);
	        }
            
            Map<Id, EmailMessage> emailMessageByCaseId = new Map<Id, EmailMessage>();
            for(EmailMessage em : emailMessages)
            {
                if(emailMessageByCaseId.containsKey(em.ParentId)
                   && emailMessageByCaseId.get(em.ParentId).CreatedDate < em.CreatedDate)
                {
                    emailMessageByCaseId.put(em.ParentId, em);
                }
                else
                {
                    emailMessageByCaseId.put(em.ParentId, em);
                }
            }
            
			for(Case cs : caseListNew)
            {
                if(cs.OwnerId == null || String.valueOf(cs.OwnerId).Left(3) != '00G') continue;
				
                String firstName = '';
                String lastName = '';
                
				if(cs.SuppliedName != null)
                {
                    if(cs.SuppliedName.contains(','))
                    {
						String[] splitWebName = cs.SuppliedName.Split(',');
                        firstName = splitWebName[1].trim();
                        lastName = splitWebName[0].trim();
                        
                        System.debug('First If Statement');
                        System.debug('Case Queueable - firstName' + firstName);
                        System.debug('Case Queueable - lastName' + firstName);
                    }
                    else
                    {
                        System.debug('else statement');
                        
                    	String[] splitWebName = cs.SuppliedName.Split(' ');
                        
                        if(splitWebName.size() == 1)
                        {
                            System.debug('else - FirstIf statement');
                            lastName = splitWebName[0];
                        }
                        else if(splitWebName.size() == 2)
                        {
                            System.debug('else - SecondIf statement');
                            
                            firstName = splitWebName[0];
                            lastName = splitWebName[1];
                        }
                        else
                        {
                            System.debug('else - Concetenate First Name statement');
                            
                            for(Integer i = 0; i < splitWebName.size() - 1; i++)
                            {
                                System.debug(splitWebName[i]);
                                firstName = firstName + splitWebName[i];
                            }

                            lastName = splitWebName[splitWebName.size() - 1];
                        }
                        
                        System.debug('Case Queueable - firstName' + firstName);
                        System.debug('Case Queueable - lastName' + firstName);
                    }
                }
				
				cs.First_Name__c = firstName;
				cs.Last_Name__c = lastName;				
                
                if(this.tt == TriggerType.isInsert) cs.Original_Queue__c = SystemUtilities.queueMap.get(cs.OwnerId).Name;

                if(Test.isRunningTest())
                {
                    setSubChannelAndDepartment(cs, cs.SuppliedEmail);
                }
                else if(emailMessageByCaseId.containsKey(cs.Id))
                {
                    setSubChannelAndDepartment(cs, emailMessageByCaseId.get(cs.Id).FromAddress);
                }
                else
                {
                    setSubChannelAndDepartment(cs, '');
                }
                
                System.debug(cs);
            }
            
            SystemUtilities.setExecuted('CaseTrigger.updateCaseContact');
            SystemUtilities.setExecuted('CaseTriggers.updateCaseFields');
            SystemUtilities.setExecuted('CaseTrigger.updateAutoCloseDate');
            
            database.update(caseListNew);
            
            SystemUtilities.resetExecuted('CaseTrigger.updateCaseContact');
            SystemUtilities.resetExecuted('CaseTriggers.updateCaseFields');
            SystemUtilities.resetExecuted('CaseTrigger.updateAutoCloseDate');
            
			// To prevent error: Maximum stack depth reached
			// This Queueable class will be tested in another test class
            //if(!Test.isRunningTest())
            //{
            //    CaseReassign_Queueable cr = new CaseReassign_Queueable();
            //    cr.caseListNew = caseListNew;
            //    System.enqueueJob(cr);                
            //}
        }
    }

    
    private static void setSubChannelAndDepartment(Case newCase, String inboundFromEmail)
    {
        Map<String, String> emailDomainToName = new Map<String, String>();
        emailDomainToName.put('amazon.com', 'Amazon');
        emailDomainToName.put('marketplace.amazon.com', 'Amazon');
        emailDomainToName.put('marketplace.amazon.de', 'Amazon');
        emailDomainToName.put('amazon.de', 'Amazon');
        emailDomainToName.put('members.ebay.com', 'eBay');
        emailDomainToName.put('ebay.com', 'eBay');
        emailDomainToName.put('relay.walmart.com', 'Walmart');
        
        Boolean isAmazon = false;
        Boolean isEbay = false;
        Boolean isWalmart = false;
        
        String inboundFromDomain = '';
        if(inboundFromEmail != '')
        {
            String[] emailSplit = inboundFromEmail.split('@');
            inboundFromDomain = emailSplit[1].toLowerCase();
            if(emailDomainToName.containsKey(inboundFromDomain))
            {
                if(emailDomainToName.get(inboundFromDomain) == 'Amazon')
                {
                    isAmazon = true;
                }
                else if(emailDomainToName.get(inboundFromDomain) == 'eBay')
                {
                    isEbay = true;
                }
                else if(emailDomainToName.get(inboundFromDomain) == 'Walmart')
                {
                    isWalmart = true;
                }
            }
        }
        
        if(inboundFromEmail == 'omniebaystore@omnimodels.com')
        {
            newCase.Sub_Channel__c = 'Omni-Ebay';
            newCase.Department__c = 'HH Customer Support';
        }
        else if(SystemUtilities.queueMap.get(newCase.OwnerId).Name == 'Athearn')
        {
            newCase.Sub_Channel__c = '';
            newCase.Department__c = 'Athearn';
        }
        else if(SystemUtilities.queueMap.get(newCase.OwnerId).Name == 'HH Consumer Sales')
        {
            newCase.Sub_Channel__c = '';
	        newCase.Department__c = 'HH Consumer Sales';
        }
        else if(SystemUtilities.queueMap.get(newCase.OwnerId).Name == 'HH Customer Support')
        {
            if(isAmazon)
            {
                newCase.Sub_Channel__c = 'Amazon';
                newCase.Department__c = 'HH Customer Support';
            }
            else if(isEbay)
            {
                newCase.Sub_Channel__c = 'eBay';
                newCase.Department__c = 'HH Customer Support';
            }
            else if(isWalmart)
            {
                newCase.Sub_Channel__c = 'Walmart';
                newCase.Department__c = 'HH Customer Support';
            }
            else
            {
                newCase.Sub_Channel__c = '';
                newCase.Department__c = 'HH Customer Support';
            }
        }
        else if(SystemUtilities.queueMap.get(newCase.OwnerId).Name == 'Omni eBay')
        {
            newCase.Sub_Channel__c = 'eBay';
            newCase.Department__c = 'Omni eBay';
        }
        else if(SystemUtilities.queueMap.get(newCase.OwnerId).Name == 'Product Support')
        {
            newCase.Sub_Channel__c = '';
            newCase.Department__c = 'Product Support';
        }
        else if(SystemUtilities.queueMap.get(newCase.OwnerId).Name == 'Sales EU')
        {
            if(isAmazon)
            {
                newCase.Sub_Channel__c = 'Amazon';
                newCase.Department__c = 'Sales EU';
            }
            else
            {
                newCase.Sub_Channel__c = '';
                newCase.Department__c = 'Sales EU';
            }
        }
        else if(SystemUtilities.queueMap.get(newCase.OwnerId).Name == 'Tech Support EU')
        {
            newCase.Sub_Channel__c = '';
            newCase.Department__c = 'Tech Support EU';
        }
        else if(SystemUtilities.queueMap.get(newCase.OwnerId).Name == 'TH Customer Support')
        {
            newCase.Sub_Channel__c = '';
            newCase.Department__c = 'TH Customer Support';
        }
        else if(SystemUtilities.queueMap.get(newCase.OwnerId).Name == 'TH Sales')
        {
            newCase.Sub_Channel__c = '';
            newCase.Department__c = 'TH Sales';
        }
    }
    
}