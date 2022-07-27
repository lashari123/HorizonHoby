@isTest
public class homepageTabAuraController_Test {
    public static testmethod void getList() {
      
      HH_Filter__c filt = new HH_Filter__c ();
     filt.Name='New Release Items';
     filt.Query_String__c='select id, Product2Id,product2.LastUpdated__c,pricebook2.Name,product2.LastInStock__c,product2.Avail__c,product2.InventoryStatus__c ,Product2.PrimaryImageID__c,toLabel(Product2.Name),toLabel(Product2.Description), Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive from PricebookEntry where  PricebookEntry.IsActive = true and   product2.FirstAppearance__c = LAST_N_DAYS:30 AND  pricebookEntry.unitPrice > 50';   
     filt.parsingString__c='Product,product2.FirstAppearance__c,=,LAST_N_DAYS:30|AND,Pricebook,pricebookEntry.unitPrice,>,50';   
     filt.isEditable__c= false ;  
     insert filt;      

      
        //HomepageTabAuraControllerv2.getLists('newstocks', '5');
        //HomepageTabAuraControllerv2.getLists('topSelling', '6');
        HomepageTabAuraControllerv2.getLists('newRelease','7');
        
        
        
  HH_Filter__c filter = new HH_Filter__c ();
     filter.Name='Newly in Stock';
     filter.Query_String__c='select id, Product2Id,product2.LastUpdated__c,pricebook2.Name,product2.LastInStock__c,product2.Avail__c,product2.InventoryStatus__c ,Product2.PrimaryImageID__c,toLabel(Product2.Name),toLabel(Product2.Description), Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive from PricebookEntry where  PricebookEntry.IsActive = true and   product2.lastinstock__c = LAST_N_DAYS:30 AND  pricebookEntry.unitPrice >= 50 AND  product2.Quantity__c > 0';   
     filter.parsingString__c=',Inventory,product2.lastinstock__c,=,LAST_N_DAYS:30|AND,Pricebook,pricebookEntry.unitPrice,>=,50|AND,Inventory,product2.Quantity__c,>,0';   
     filter.isEditable__c= false ;  
     insert filter;      

      
        HomepageTabAuraControllerv2.getLists('newstocks', '5');
        
        
        
        
      
    
     HH_Filter__c filt1 = new HH_Filter__c ();
     filt1.Name='Top Selling Items';
     filt1.Query_String__c='select id, Product2Id,product2.LastUpdated__c,pricebook2.Name,product2.LastInStock__c,product2.Avail__c,product2.InventoryStatus__c ,Product2.PrimaryImageID__c,toLabel(Product2.Name),toLabel(Product2.Description), Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive from PricebookEntry where  PricebookEntry.IsActive = true and   product2.avgDemand__c > 100 AND  pricebookEntry.unitPrice > 50';   
     filt1.parsingString__c=',Product,product2.avgDemand__c,>,100|AND,Pricebook,pricebookEntry.unitPrice,>,50';   
     filt1.isEditable__c= false ;  
     insert filt1;      

     HomepageTabAuraControllerv2.getLists('topSelling', '6');
       
           
             
    }
    
    
}