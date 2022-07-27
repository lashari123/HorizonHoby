public class CheckoutController {
    @AuraEnabled
    public static string getOrderLineItemsDetails(String orderID){
        system.debug(orderID);
        system.debug(OrderController.orderItemsDetailslCheckout(orderID));
        return JSON.serialize(OrderController.orderItemsDetailslCheckout(orderID));
        
    }
      @AuraEnabled
    public static void authorizedOrder(String orderID){
        order o =new order(id = orderId, status = 'pending');
        update o;
          
    }
    
    @AuraEnabled
    public static map<string,string> getTranslations(string langCode){
        map<string,string> translations = new map<string,string>();
        if(langCode == 'de'){
            translations = TranslationHelper.getAllGermanTranslation('Cart');
        }
        else if(langCode == 'fr' ){
            translations = TranslationHelper.getAllFrenchTranslation('Cart');
        }
        translations.put('langCode',langCode);
        return translations;
    }
}