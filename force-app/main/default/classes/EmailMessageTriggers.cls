public class EmailMessageTriggers 
{
    // Re-open the case with a Case Status of "Customer Responded" if the Case has only been closed for less than 14 days
    // Update the Customer_Last_Response_Date_Time__c as well
    // We do not want to reopen a Case if the FROM email address is not related to the SuppliedEmail or the Contact's Email address
    // 
    // The reason for the .toLowerCase() function is the function set.contains() is case sensitive. 
    // Even though 
    public static void reopenClosedCases(List<EmailMessage> emailMessagesNew, TriggerType tt)
    {
        Set<Id> caseIds = new Set<Id>();
        Map<Id, EmailMessage> emailMsgByCaseId = new Map<Id, EmailMessage>();
        for(EmailMessage em : emailMessagesNew)
        {
            if(em.RelatedToId != null
               && String.valueOf(em.RelatedToId).left(3) == '500')
            {
                caseIds.add(em.RelatedToId);
                emailMsgByCaseId.put(em.RelatedToId, em);
            }
        }
        
        if(caseIds.IsEmpty()) return;

        List<Case> casesToReview = new List<Case>([SELECT Id, Status, Sub_Status__c, ClosedDate, IsClosed, Auto_Close_Date__c,
                                                          Account.PersonEmail, Contact.Email, SuppliedEmail, 
                                                          Customer_Last_Response_Date_Time__c
                                                     FROM Case
                                                    WHERE Id IN :caseIds]);
        
        if(casesToReview.isEmpty()) return;
        
        Set<String> toEmail = new Set<String>();
        Set<String> fromEmail = new Set<String>();
        for(EmailMessage em : emailMessagesNew)
        {
            if(em.ToAddress != null && em.ToAddress != '')
            {
            	toEmail.add(em.ToAddress.toLowerCase());                
            }
            
            if(em.FromAddress != null && em.FromAddress != '')
            {
            	fromEmail.add(em.FromAddress.toLowerCase());                
            }
        }
        
        List<Case> casesToUpdate = new List<Case>();
        for(Case cs : casesToReview)
        {
            Boolean isCustomerEmail = false;
            Boolean isAgentToCustomerEmail = false;
                
            if(fromEmail.Contains(cs.SuppliedEmail)
               || fromEmail.Contains(cs.Account.PersonEmail)
               || fromEmail.Contains(cs.Contact.Email))
            {
                isCustomerEmail = true;
            }
            
            if(toEmail.Contains(cs.SuppliedEmail)
               || toEmail.Contains(cs.Account.PersonEmail)
               || toEmail.Contains(cs.Contact.Email))
            {
                isAgentToCustomerEmail = true;
            }
            
            // Check if the Case in scope should be reopened or not, if it has been closed
            if(isCustomerEmail == true 
               && cs.IsClosed == true)
            {
            	Date dtClosed = Date.newInstance(cs.ClosedDate.year(), cs.ClosedDate.month(), cs.ClosedDate.day());

                cs.Status = 'Open';
                cs.Sub_Status__c = 'Open: Customer Revived Ticket';
                cs.Customer_Last_Response_Date_Time__c = Datetime.now();

                casesToUpdate.add(cs);
            }
// TODO: For New tickets, this should be new. Add some additional parameters to prevent the status from changing
// to Customer Responded for new cases.
// Get the list of open cases per each customer
// How do we determine if a Case is New or not?
            else if(isCustomerEmail == true
                   && cs.isClosed == false
                   && cs.Status != 'New')
            {
                cs.Status = 'Open';
                cs.Sub_Status__c = 'Open: Customer Responded';
                cs.Customer_Last_Response_Date_Time__c = Datetime.now();
                
                casesToUpdate.add(cs);
            }
            // logic to handle whether it is an internal email between the agents or if it was sent to the customer
            else if(isCustomerEmail == false
                   && isAgentToCustomerEmail)
            {
                cs.Status = 'Open';
                cs.Sub_Status__c = 'Open: Need Customer reply';
                casesToUpdate.add(cs);
            }
        }
        
        if(!casesToUpdate.isEmpty())
        {
            database.update(casesToUpdate, false);
        }
    }
}