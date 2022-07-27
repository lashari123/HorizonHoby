public class OrderSummaryController {

    @auraEnabled 
    Public static string  getOrders(Boolean isBackOrder){
        if(!isBackOrder){
        	return OrderController.AllOrder();
        } else{
            return OrderController.AllBackedOrder();
        }
    }
}