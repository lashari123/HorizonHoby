/*
@Description : Account Object Trigger Helper.
*/
public class AccountTriggerHelper
{
    /*
     * Based on accounts personemail, query all possible cases and associate account with cases
     */
    public static void associateCase(List<Account> acctListNew)
    {
        //Preparing PersonEmail Vs AccountMap
        Map<String,Account> emailAccountMap = new Map<String,Account>();
        List<Case> updCaseList = new List<Case>();
        List<Id> accIdList = new List<Id>();
        for(Account ac : acctListNew)
        {                             //We check for all the three email fields and put it in map
            if(Trigger.isInsert) {
                if(ac.PersonEmail !=null){
            	emailAccountMap.put(ac.PersonEmail.deleteWhitespace(),ac);
                }
                if(ac.Email2__pc !=null){
                 emailAccountMap.put(ac.Email2__pc.deleteWhitespace(),ac);
                }
                if(ac.Email3__pc !=null){
                 emailAccountMap.put(ac.Email3__pc.deleteWhitespace(),ac);
                }
            }
            
            if(Trigger.isUpdate)           //We check for update on the particular field
            {
                Account oldac = (Account) Trigger.oldMap.get(ac.Id);
                if(ac.PersonEmail != null && ac.PersonEmail != oldac.PersonEmail) {
                    emailAccountMap.put(ac.PersonEmail.deleteWhitespace(),ac);
                }
                if(ac.Email2__pc != null && ac.Email2__pc != oldac.Email2__pc) {
                    emailAccountMap.put(ac.Email2__pc.deleteWhitespace(),ac);
                }
                if(ac.Email3__pc != null && ac.Email3__pc != oldac.Email3__pc) {
                    emailAccountMap.put(ac.Email3__pc.deleteWhitespace(),ac);
                }
            }
        }
   
        //Query all cases whose email address matches with case email fields
        List<Case> caseList = new List<Case>([SELECT Id, AccountId, ContactId, SuppliedEmail,ContactEmail
                                              FROM Case 
                                              WHERE SuppliedEmail IN:emailAccountMap.keySet() 
                                               AND createddate>=2020-06-22T00:00:00z AND AccountId = null AND (NOT owner.name LIKE 'Email SPAM')]);
        
        List<Case> caseListToUpdate = new List<Case>();
        for(Case cs : caseList)
        {
            //Account Person email matches with case email then associate account with case
            if(emailAccountMap.containsKey(cs.SuppliedEmail)) 
            {
                cs.AccountId = emailAccountMap.get(cs.SuppliedEmail).Id;
                cs.ContactId = emailAccountMap.get(cs.SuppliedEmail).PersonContactId;
                caseListToUpdate.add(cs);
            } 
            else if (emailAccountMap.containsKey(cs.ContactEmail))
            {
                cs.AccountId = emailAccountMap.get(cs.ContactEmail).Id;
                cs.ContactId = emailAccountMap.get(cs.ContactEmail).PersonContactId;
                caseListToUpdate.add(cs);
            }
        }
            system.debug('caseListToUpdate-->'+caseListToUpdate);
            //AccountTriggerHandler.TriggerDisabled = true;  // Use this to bypass the account trigger in transaction to avoid recurssion
            database.update(caseListToUpdate);
            //AccountTriggerHandler.TriggerDisabled = false;
        }
    }