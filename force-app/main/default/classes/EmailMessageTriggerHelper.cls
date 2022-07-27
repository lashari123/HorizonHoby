/**
 * @description       : Helper class to automate case status based of email 
 * @author            : Akshith
 * @group             : 
 * @last modified on  : 11-25-2020
 
 
**/
public class EmailMessageTriggerHelper {
  public static void casestatusUpdate(List<EmailMessage> emailMessagesNew) {
    try {
      System.debug('casestatusUpdate');

      Set<Id> caseIds = new Set<Id>();
      for (EmailMessage em : emailMessagesNew) {
        if (
          em.RelatedToId != null &&
          String.valueOf(em.RelatedToId).left(3) == '500'
        )
          caseIds.add(em.RelatedtoId);
      }
      List<Case> CaseList = new List<Case>(
        [
          SELECT
            Id,
            Status,
            Sub_Status__c,
            ClosedDate,
            IsClosed,
            Auto_Close_Date__c,
            Account.PersonEmail,
            Contact.Email,
            SuppliedEmail,
            Customer_Last_Response_Date_Time__c,
            Auto_Closed__c
          FROM Case
          WHERE Id IN :caseIds
        ]
      );

      Set<String> toEmail = new Set<String>();
      Set<String> fromEmail = new Set<String>();
      String EmailBody;
      for (EmailMessage em : emailMessagesNew) {
        if (em.ToAddress != null && em.ToAddress != '') {
          toEmail.add(em.ToAddress.toLowerCase());
        }

        if (em.FromAddress != null && em.FromAddress != '') {
          fromEmail.add(em.FromAddress.toLowerCase());
        }
        if (em.TextBody != null && em.TextBody != '') {
          EmailBody = em.TextBody;
        }
      }
      List<Case> casesToUpdate = new List<Case>();
      for (EmailMessage E : emailMessagesNew) {
        for (Case cs : CaseList) {
          System.debug(LoggingLevel.FINE, E);
          System.debug(cs);
          Boolean isCustomerEmail = false;
          Boolean isAgentToCustomerEmail = false;
          Boolean EmailBodyCheck = false;

          if (
            fromEmail.Contains(cs.SuppliedEmail) ||
            fromEmail.Contains(cs.Account.PersonEmail) ||
            fromEmail.Contains(cs.Contact.Email)
          ) {
            isCustomerEmail = true;
          }
          if (
            toEmail.Contains(cs.SuppliedEmail) ||
            toEmail.Contains(cs.Account.PersonEmail) ||
            toEmail.Contains(cs.Contact.Email)
          ) {
            isAgentToCustomerEmail = true;
          }

          if (isCustomerEmail && cs.Status == 'New') {
            cs = EmailToCaseHelper.processEmailToCase(E, cs);
          }

          if (
            isCustomerEmail &&
            ((!cs.IsClosed &&
            cs.Status != 'New' &&
            cs.status != 'Merged' &&
            cs.status != 'Closed' &&
            cs.status != 'Re-Opened' &&
            !cs.Auto_Closed__c) && cs.Status == 'Waiting for Customer Reply')
          ) {
            cs.Status = 'Customer Response Received';
            cs.Customer_Last_Response_Date_Time__c = Datetime.now();
          } else if (
            isCustomerEmail &&
            (cs.IsClosed && (E.MessageDate.day() - cs.ClosedDate.day() <= 14))
          ) {
            cs.Status = 'Re-Opened';
            cs.Customer_Last_Response_Date_Time__c = Datetime.now();
          } else if (isAgentToCustomerEmail && cs.Status != 'Closed') {
            cs.Status = 'Waiting for Customer Reply';
          }

          casesToUpdate.add(cs);
        }
      }
      Database.update(casestoUpdate);
    } catch (Exception ex) {
      ExceptionLogger.LogException(ex);
    }
  }
}