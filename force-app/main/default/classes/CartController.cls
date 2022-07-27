public class CartController {
    @AuraEnabled
    public static string orderItemsbyOrderId(String orderID){
        system.debug(orderID);
        system.debug(OrderController.orderItemsbyOrderId(orderID));
        return JSON.serialize(OrderController.orderItemsbyOrderId(orderID));
        
    }
    
    @AuraEnabled
    public static List<Order> getOrders() {
        
        return OrderController.getAllOrders();
    }
   
    @AuraEnabled
    public static string getOrderLineItems(String orderID){
        system.debug(orderID);
        system.debug(OrderController.orderItemsbyOrderId(orderID));
        return JSON.serialize(OrderController.orderItemsbyOrderId(orderID));
        
    }
     
    @AuraEnabled
    public static string getOrderLineItemsDetails(String orderID,string userId){
        system.debug(orderID);
        system.debug(OrderController.orderItemsDetailslbyOrderId(orderID,userId));
        return JSON.serialize(OrderController.orderItemsDetailslbyOrderId(orderID,userId));
        
    }
    
    @AuraEnabled
    public static string orderLineItemsGroupByAlerts(String orderID){
        return OrderController.orderLineItemsGroupByAlerts(orderID);
    }
   
    @AuraEnabled
    public static void UpdateLineItem(string lines ){
        
        orderitem[] linesSer = (orderItem[]) JSON.deserialize(lines, orderItem[].class);
        
        for(orderitem item : linesSer){
            item.TotalLineAmount = item.Quantity *  item.UnitPrice;
        }
        update linesSer;
    }
    
    @AuraEnabled
    public static void updateOrderInfo(string oid,string poNumber,string description, string endDate ){
        
      
        update new order(id =oid, description = description,poNumber=poNumber , endDate = Date.valueOf(endDate));
    }
    
    @AuraEnabled
    public static void UpdateName(String Name, String oid) {
        OrderController.UpdateOrderName(Name, oid);
    }
    
    public class SelectedOrderLineItemWrapper {
        public String ProductCode {get; set;} 
        
    }
    
    @AuraEnabled
    public static String [] generateListForProducts(list<object> products) {
        String [] prodList = new list<String>();
        
        for(object prd : products){
            map<object,object> t= ( map<object,object>)prd;
            
            Integer quantity =Integer.valueOf(t.get('Quantity'));
            
            map<object,object> pd= ( map<object,object>)t.get('Product2');
            //SelectedOrderLineItemWrapper pd =(SelectedOrderLineItemWrapper)t.get('Product2');
            //SelectedOrderLineItemWrapper pd = (SelectedOrderLineItemWrapper)JSON.deserialize(t.get('Product2'), SelectedOrderLineItemWrapper.class);
            String pcode = (String)pd.get('ProductCode');
            String prod = pcode + '_' + quantity;
            
            prodList.add(prod);
        }
        return prodList;
    }
    
    @AuraEnabled
    public static String AddToNewOrder(String skuQuantityListString, String orderID, list<object> products, Boolean deleteAll) {
        deleteOrderLineItems(orderID, products, deleteAll);
        return OrderController.addToNewOrder(skuQuantityListString);
        
    }
    
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
    
    @AuraEnabled
    public static String downloadFile(string HtmlText) {
        return HtmlPrintController.downloadHtmlFile(HtmlText);
    }
    
    @AuraEnabled
    public static map<string,string> getTranslations(string langCode){
        map<string,string> translations = new map<string,string>();
        if(langCode == 'de'){
            translations = TranslationHelper.getAllGermanTranslation('Search');
            translations.putAll(TranslationHelper.getAllGermanTranslation('Cart'));
        }
        else if(langCode == 'fr' ){
            translations = TranslationHelper.getAllFrenchTranslation('Search');
            translations.putAll(TranslationHelper.getAllFrenchTranslation('Cart'));
        }
        translations.put('langCode',langCode);
        return translations;
    }
}