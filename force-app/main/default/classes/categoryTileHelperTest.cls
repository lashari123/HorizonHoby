@IsTest
global class categoryTileHelperTest implements HttpCalloutMock {
    static testMethod void testPostCallout() {
        Test.setMock(HttpCalloutMock.class, new categoryTileHelperTest());  
        categoryHelper.getCategories();
    }
    public static testmethod void categoryTileHelperTest() { 
     
    categoryTileHelper.getAllCategories();
          
    }
    
    
    public static testmethod void categoryHelperTest() { 
     
    categoryhelper.getAllCategories();
          
 }
    
     public static testmethod void categoryHelpTest() { 
           categoryHelper.getNavigationalCategories() ;
         
         
   List<productCategory> productctg = new List<productCategory>();
          
       ProductCatalog plog = new ProductCatalog ();
       plog.Name='Test';
       insert plog;  
       
       productCategory prdcategory = new productCategory();
       prdcategory.Name='bilal';
       prdcategory.IsNavigational = true;
       prdcategory.CatalogId = plog.id;
       insert prdcategory;
         
       
       productCategory prdcategoryChild = new productCategory();
       prdcategoryChild.Name='Test';
       prdcategoryChild.IsNavigational = true;
       prdcategoryChild.CatalogId = plog.id;
       prdcategoryChild.ParentCategoryId=prdcategory.id;
       insert prdcategoryChild;
     
       categoryHelper.getNavigationalParentCategories();
     }
    
    public static testmethod void imageupload() {
        
        
       ProductCatalog plog = new ProductCatalog ();
       plog.Name='Test';
       insert plog;
        
        
       productCategory pc = new productCategory();
       pc.Name='test1';
       pc.IsNavigational = true;
       pc.CatalogId = plog.id;
       insert pc;
       
       CategoryHelper.uploadImage(pc.id, True, 'YSAxDQpiIDINCmMgMw0KZCA0DQplIDUNCmYgNiANCmcgNw0K', 'Test');
         
       
    }
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Test": {"name":"Test"}}');
        response.setStatusCode(200);
        return response; 
    }
        
    }