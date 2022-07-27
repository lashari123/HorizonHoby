/*
 -- Created By: Fasih | Date: 9/9/21
*
-- Decription: Handling all Soql query for productCategory object.
*/

public class CategoryHelper {
    
    //return All active, inactive category
    public static list<productCategory> getAllCategories(){
        return [SELECT IsNavigational, Id,Banner_Image_Id__c,primaryImageId__c, IsDeleted, toLabel(Name), CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, CatalogId, ParentCategoryId, toLabel(Description), NumberOfProducts, SortOrder FROM ProductCategory];
    }
    
    //return All navigational Category (Show in Menu)
     public static list<productCategory> getNavigationalCategories(){
        return [SELECT IsNavigational, Id,Banner_Image_Id__c,primaryImageId__c, IsDeleted, toLabel(Name), CreatedDate, CreatedById, LastModifiedDate,
                LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, CatalogId, ParentCategoryId, toLabel(Description), NumberOfProducts, SortOrder
                FROM ProductCategory Where IsNavigational = true  order by sortOrder ASC];
    }
    
      //return All navigational Category (Show in Menu)
     public static list<productCategory> getNavigationalParentCategories(){
        return [SELECT IsNavigational, Id,Banner_Image_Id__c,primaryImageId__c, IsDeleted, toLabel(Name), CreatedDate, CreatedById, LastModifiedDate, 
                LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, CatalogId, ParentCategoryId, toLabel(Description), NumberOfProducts, SortOrder 
                FROM ProductCategory Where IsNavigational = true and ParentCategoryId = '' order by sortOrder ASC];
    }
    
    @AuraEnabled
    public static void uploadImage(string RecordId,boolean isTile ,string Base64String,string stringName) {
        
        List<Folder> folderList = [SELECT Id, Name From Folder WHERE Name = 'B2B General Documents'];
        String docFolderId = folderList[0].Id; //Get Folder Id
        String fileContent = Base64String;
        Datetime currentDT = System.now();
       // String fileName = 'Media POC Image'; //Timestamp for unique file name
        
        
          
        Document newImage = new Document();
        newImage.Name = stringName;
        newImage.Body = EncodingUtil.base64Decode(fileContent);
        newImage.ContentType = 'image/jpeg';
        newImage.Type = 'jpg';
        newImage.FolderId = docFolderId;
        Insert newImage;
        
        
        ProductCategory cat = new ProductCategory( id= recordId);
        if(isTile){
         cat.primaryImageId__c =newImage.Id;
        }
        else{
            cat.Banner_Image_Id__c  =newImage.Id;
        }
        
        update cat;
    }
    
     public static void getCategories(){
        
        mulesoftHandler.tokenWrapper token = mulesoftHandler.getToken();
        
        Http protocol = new Http();
        
        HttpRequest request = new HttpRequest();
        system.debug(mulesoftHandler.m_baseUrl + '/accounts/login'	);
        request.setEndpoint(mulesoftHandler.m_baseUrl + '/mocking/api/v1/sources/exchange/assets/41a75cd2-c0e2-4e87-ace1-108af8abd73f/product-catalog/1.0.0/m/categories');
        request.setMethod('GET');
        request.setHeader('Accept', '*/*'); 
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept-Encoding', 'gzip, deflate, br');
        request.setHeader('Connection', 'keep-alive');
        string auth = 'Bearer ' +token.access_token;  
        
        system.debug(auth);
        request.setHeader('ms2-authorization' ,auth);
        request.setHeader('client_id' ,'abc');
        request.setHeader('client_secret' ,'abc');
        
        
        
        request.setTimeout(120000);
        
        HttpResponse response = protocol.send(request );
        
        
        System.debug('body22222===='+response.getBody());
        
        
        
        
        
    }
    

}