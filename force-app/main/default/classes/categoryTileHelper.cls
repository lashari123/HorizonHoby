public class categoryTileHelper {
    @auraEnabled(cacheable=true)
    public static  List<productCategory> getAllCategories(){
        return CategoryHelper.getNavigationalParentCategories();
    }
}