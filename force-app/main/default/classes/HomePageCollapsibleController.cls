public with sharing class HomePageCollapsibleController {
     @AuraEnabled(cacheable=true)
    public static List<Order> getOrder(string Status){
 
        if(Status == 'Draft'){
            return OrderController.getAllOrders(5);     
        }
        else if(Status == 'Submitted'){
           return OrderController.getAllSubmittedOrders(5);     
        }
      
        else if(Status == 'Activated'){
           return OrderController.getAllActivatedOrders(5);     
        }
        else if(Status == 'Completed'){
           return OrderController.getAllCompletedOrders(5);     
        }

      
        return null;
       // return  [select id, Status, PoNumber , OrderNumber, EffectiveDate, OwnerId from Order where OwnerId =: Userinfo.getUserid() and Status = :status];                           
       
    }
      @AuraEnabled(cacheable=true)
    public static List<OrderItem> getBackedOrder(){
 
         return OrderController.getAllBackedOrders(5);     
      
      
       // return  [select id, Status, PoNumber , OrderNumber, EffectiveDate, OwnerId from Order where OwnerId =: Userinfo.getUserid() and Status = :status];                           
       
    }
    @AuraEnabled(cacheable=true)
    public static List<Invoice__c> getInvoiceHistory(){
 
         return  [select id, Name, Invoice_Date__c,Status__c
           from Invoice__c where order__c in :getOrder('Completed')];                           
       
    }

}