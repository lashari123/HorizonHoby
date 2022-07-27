public class OrderDetailPageController {
    @AuraEnabled
    public static string getOrderLineItemsDetails(String orderID){
        
        return JSON.serialize(OrderController.orderItemsDetailslbyOrderId(orderID,UserInfo.getUserId()));
        
    }
    @AuraEnabled
    public static string getOrderLineItems(String orderID){
       // system.debug(orderID);
        //system.debug(OrderController.orderItemsbyOrderId(orderID));
        return JSON.serialize(OrderController.orderItemsbyOrderId(orderID));
        
    }
    
}