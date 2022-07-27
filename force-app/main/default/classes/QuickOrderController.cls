public class QuickOrderController {
	@AuraEnabled
    public static Boolean CheckSKUValidity(String sku){
        return ProductHelper.isSKUValid(sku);
    }
}