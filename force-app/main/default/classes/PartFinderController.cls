public class PartFinderController {
    
    @AuraEnabled
    public static List<Manufacturer__c> getManufacturersList(){        
        return ManufacturerHelper.getManufacturers();
    }
    
    @AuraEnabled
    public static List<Product2> getProductList(String manId){  
        List<Product2> prodList = new List<Product2>();
        prodList = [SELECT Id, Name FROM Product2 WHERE Manufacturer__c =: manId];
        return prodList;
    }

}