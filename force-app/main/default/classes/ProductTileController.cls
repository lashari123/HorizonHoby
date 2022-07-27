public class ProductTileController {
    @AuraEnabled
    public static list<PricebookEntry> TopSellingProducts(){
        return ProductHelper.getTopSellingProducts();    
    }

}