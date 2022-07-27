public  class FetchAllCases {
    @AuraEnabled(Cacheable=True)
    public static List<Case> getAllCases(Id recordId) {
        List <Account> accPartyId =new List<Account>([SELECT id,Name,GlobalPartyId FROM Account where Id =:recordId]);
        system.debug('Account-->'+accPartyId);
        if(accPartyId[0].GlobalPartyId != null){
            // Query to get Person ContactId using Global PartyId
            List <Account> accList =new List<Account>([SELECT id,Name,Case_Safe_Contact_Id__pc,Channel__pc,Customer_Number__pc FROM Account where GlobalPartyId =:accPartyId[0].GlobalPartyId]);
            system.debug('Account-->'+accList);
            
            //Acc Ids set
            set<Id> accSet=new set<Id>();
            for(Account accIds:accList){
                accSet.add(accIds.Id);
            }
            
           // query the cases using account Ids
           // 
          
        
        List<Case> caseList=new List<Case>([SELECT id,CaseNumber,Channel__c,Customer_Channel__c,Status,Department__c,Reason,CreatedDate,ClosedDate,Origin,Subject,AccountId FROM Case where AccountId in : accSet]);
            return caseList;   
            
        }
       else{
                 List<Case> caseList=new List<Case>([SELECT id,CaseNumber,Channel__c,Customer_Channel__c,Status,Department__c,Reason,CreatedDate,ClosedDate,Origin,Subject,AccountId FROM Case where AccountId=: accPartyId[0].Id]);
            return caseList;
            }
    
}
}