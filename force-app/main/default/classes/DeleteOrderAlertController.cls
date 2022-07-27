public class DeleteOrderAlertController {
	@AuraEnabled
    public static String deleteOrderLineItems(String orderID, list<object> products, Boolean deleteAll) {
        List<OrderItem> oi = new List<OrderItem>();
        List<Order> order = new List<Order>();
        Set<String> oidSet = new Set<String>();
        
        for(object prd : products){
            map<object,object> t= ( map<object,object>)prd;
            
            String orderItemId =String.valueOf(t.get('Id'));
            
            oidSet.add(orderItemId);
        }
        try {
            oi = [SELECT Id FROM OrderItem WHERE OrderId =: orderID AND Id IN:oidSet  ];
            delete oi;
            //If all order items are selected then will delete the draft as well along with order line item
            if(deleteAll){
                order = [SELECT Id FROM Order WHERE Id =: orderID];
                delete order;
            } 
        } catch(DmlException e) {
            return 'Error: ' + e.getMessage();
        }
        
        
        return 'SUCCESS';
    }
}