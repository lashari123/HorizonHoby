public class AccountDetailController {
    @AuraEnabled
    public static string getAccountDetail(){
        User userContact = [Select Contact.Accountid,contact.Email,contact.Name from User where Id =:userInfo.getUserId() limit 1 ];
        Account acc = [SELECT ID , Name  ,Phone,BillingStreet,shipping_type__C,payment_type__c, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry   from Account where id = :userContact.Contact.Accountid];
        AccountDetailWrapper adw = new AccountDetailWrapper();
        adw.Name = userContact.contact.Name;
        adw.Email = userContact.contact.Email;
        adw.CreditType = acc.shipping_type__c;
        adw.paymentType = acc.payment_type__c;
        adw.ShippingAddress = acc.ShippingStreet + ' ' + acc.ShippingCity + ' ' + acc.ShippingState + ' ' + acc.ShippingCountry ;
        adw.ShippingContact = acc.Phone;
        adw.ShippingStoreName = 'Store 1';
        adw.BillingAddress = acc.BillingStreet + ' ' + acc.BillingCity + ' ' + acc.BillingState + ' ' + acc.BillingCountry ;
        adw.BillingContact = acc.Phone;
        adw.BillingStoreName = 'Store 1';
        
        return json.serialize(adw);
    } 
    public class AccountDetailWrapper{
       @AuraEnabled
        public string Name {get;set;}
        @AuraEnabled
        public string Email {get;set;}
        @AuraEnabled
        public string CreditType {get;set;}
        @AuraEnabled
        public string PaymentType {get;set;}
        
        @AuraEnabled
        public string ShippingAddress {get;set;}
        @AuraEnabled
        public string ShippingContact {get;set;}
        @AuraEnabled
        public string ShippingStoreName {get;set;}
        @AuraEnabled
        public string BillingAddress {get;set;}
        @AuraEnabled
        public string BillingContact {get;set;}
        @AuraEnabled
        public string BillingStoreName {get;set;}
    }
}