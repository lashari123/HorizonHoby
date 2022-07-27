public class DealerInfoController {
    
    @AuraEnabled
    public static resultWrapper getDealerInfo(){
        
        User userRec  = [Select Id,Name, Email, ContactId from User where Id=:  UserInfo.getUserId()];
        
        string contactId= userRec.ContactId;
        Contact contactRec = [Select Id,Name, AccountId from Contact where Id=: contactId];
        
        string AccountId=contactRec.AccountId;
        Account accRec = [Select Id,Name,AccountNumber,Credit_Type__c, Payment_Type__c, Shipping_Type__c,
                          BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,
                          ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry
                          from Account where Id=:AccountId];
        
        List<Contact> primaryContact = [Select Id,Name,Email,Phone, AccountId, Is_Primary__c from Contact where
                                       AccountId=:AccountId and Is_Primary__c=true limit 1];
        
        
        resultWrapper wrapper = new resultWrapper();
        wrapper.accountRec= accRec;
        if(primaryContact.size()>0){
            wrapper.primaryContact=primaryContact[0];
        }
        //wrapper.MonthlySale=totalMonthlySale;
        //wrapper.SaleColor=monthlySaleColor;
        
        return wrapper;
    }
    
    public class resultWrapper{
        
        @AuraEnabled
        public  Contact primaryContact {get;set;}
        @AuraEnabled
        public  Account accountRec {get;set;}
        
    }


}