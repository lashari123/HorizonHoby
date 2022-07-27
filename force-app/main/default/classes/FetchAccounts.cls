public  class FetchAccounts {
    @AuraEnabled(Cacheable=True)
    public static List<Account> getAllAccounts(Id recordId) {
        List <Account> accPartyId =new List<Account>([SELECT id,Name,GlobalPartyId FROM Account where Id =:recordId]);
        system.debug('Account-->'+accPartyId);
        if(accPartyId[0].GlobalPartyId != null){
            // Query to get Person ContactId using Global PartyId
            List <Account> accList =new List<Account>([SELECT id,Name,Case_Safe_Contact_Id__pc,Channel__pc,Customer_Number__pc FROM Account where GlobalPartyId =:accPartyId[0].GlobalPartyId]);
            system.debug('Account-->'+accList);
            return accList;
            
        }
        return null;
    }
}