public with sharing class HtmlPrintController {

   
    @AuraEnabled
    public static list<productTableWrapper> getProductList(List<String> recIds, Integer caseNo,string keyword, string filterID){
        return storeListViewHandler.getProductList(recIds, caseNo, keyword, filterID);
    }
    @auraEnabled 
    Public static string  getOrders(Boolean isBackOrder){
        if(!isBackOrder){
        	return OrderController.AllOrder();
        } else{
            return OrderController.AllBackedOrder();
        }
    }
     @AuraEnabled
     public static String downloadHtmlFile(string HtmlText) {
        return EncodingUtil.base64Encode(Blob.valueOf(htmlText));
    }
}