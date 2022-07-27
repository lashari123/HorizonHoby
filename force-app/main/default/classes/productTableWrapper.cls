public class productTableWrapper{
    @AuraEnabled
    public string product2Id = '';
    @AuraEnabled public string name= '';
    @AuraEnabled public string stockKeepingUnit='';
    @AuraEnabled public string description='';
    @AuraEnabled public string category='';
    @AuraEnabled public decimal retail=0;
    @AuraEnabled public integer Quantity=0;
    @AuraEnabled public decimal dealer=0;
    @AuraEnabled public string releaseDate='early dec';
    @AuraEnabled public  PricebookEntry pbe;
    
    
}