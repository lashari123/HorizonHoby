public without sharing class ProductHelper {
    @AuraEnabled
    public static list<PricebookEntry> getTopSellingProducts(){
        system.debug('testing');
        Set<String> productIdList = new Set<String>{'01t6t0000001UdOAAU', '01t6t0000001UdTAAU', '01t6t0000001UdYAAU', '01t6t00000031deAAA', '01t6t00000032dEAAQ', '01t6t00000032d9AAA'};
            list<PricebookEntry> PricebookEntryList = new list<PricebookEntry>();
        PricebookEntryList = [select id, Product2Id, toLabel(Product2.Name), toLabel(Product2.Description), Product2.PrimaryImageID__c, UnitPrice, IsActive from PricebookEntry where IsActive = true and pricebook2.name ='Dealer Price Book'and  Product2Id IN :productIdList];
        if(PricebookEntryList.size() > 0){
            /* for(PricebookEntry PricebookEntry : PricebookEntryList){
PricebookEntry.Product2.Description = PricebookEntry.Product2.Description.substring(0, 255);
}*/
            return PricebookEntryList;
        } else {
            return null;
        }
        
        /*
list<order> Orders =  [select id, tolabel(Status), PoNumber , OrderNumber,OrderedDate, EffectiveDate, OwnerId 
from Order where OwnerId =: Userinfo.getUserid() and Status ='Backed Order'];
return [select id, Product2Id,Quantity,order.PONumber, order.OrderNumber,order.EffectiveDate from OrderItem  where OrderId in:orders];*/
    }
    
    
    public static Attachment uploadImage(string RecordId,boolean isPrimary,string Base64String,string stringName) {
        
        List<Folder> folderList = [SELECT Id, Name From Folder WHERE Name = 'B2B General Documents'];
        String docFolderId = folderList[0].Id; //Get Folder Id
        String fileContent = Base64String;
        Datetime currentDT = System.now();
        // String fileName = 'Media POC Image'; //Timestamp for unique file name
        
        Attachment newImage = new Attachment();
        
        newImage.Name = stringName;
        newImage.Body = EncodingUtil.base64Decode(fileContent);
        newImage.ContentType = 'image/jpeg';
        newImage.ParentId = RecordId;
        
        return NewImage;
        
        //  insert newImage;
        
        /* if(isPrimary){
Product2 prd = new product2(
id= recordId,
primaryImageId__c =newImage.Id

);*/
        //  update prd;
        //}
    }
    
    
    public static void uploadImageByAnonymous(string RecordId,boolean isPrimary,string Base64String,string stringName) {
        
        List<Folder> folderList = [SELECT Id, Name From Folder WHERE Name = 'B2B General Documents'];
        String docFolderId = folderList[0].Id; //Get Folder Id
        String fileContent = Base64String;
        Datetime currentDT = System.now();
        // String fileName = 'Media POC Image'; //Timestamp for unique file name
        
        Attachment newImage = new Attachment();
        
        newImage.Name = stringName;
        newImage.Body = EncodingUtil.base64Decode(fileContent);
        newImage.ContentType = 'image/jpeg';
        newImage.ParentId = RecordId;
        
        //return NewImage;
        
        insert newImage;
        
        if(isPrimary){
            Product2 prd = new product2(
                id= recordId,
                primaryImageId__c =newImage.Id
                
            );
            update prd;
        }
    }
    
    
    
    @AuraEnabled 
    public static String getImage() {
        List<Document> doc = new List<Document>();
        doc = [Select Id, Name from Document where Name = 'Media POC Image'];
        return doc[0].Id;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<string> getImages(string pid){
        
        List<Product2> prod = new List<Product2>();
        prod = [SELECT Id, primaryImageID__c FROM Product2 WHERE id =: pid];        
        attachment[] images = [select id,name from attachment where parentId = :pid];
        set<string> imagesURL = new set<string>();
        string url = '../servlet/servlet.FileDownload?file='+prod[0].primaryImageID__c;
        imagesURL.add(url);
        for(attachment image : images ){
            url = '../servlet/servlet.FileDownload?file='+image.id;
            imagesURL.add(url);
        }
        
        return new List<String>(imagesURL);
    }
    
    @AuraEnabled(cacheable=true)
    public static list<image__c> getFeaturedImages(string pid){
        
        image__c [] featuredImages = [SELECT id,name,ImageUrl__C,Description__C FROM Image__c WHERE isFeatured__c = true and Product__c = :pid ];
        return featuredImages;
    }
    
    //Get Videos for showing on Product Detail Page Slider
    @AuraEnabled(cacheable=true)
    public static list<Video__c> getSliderVideos(string pid){
        List<Video__c> featuredVideos = new List<Video__c>();
        featuredVideos = [SELECT Id, Video_URL__c FROM Video__c WHERE Product__c = :pid ];
        return featuredVideos;
    }
    
    
    //SKU have been replaced with ProductCode based on the new requirement
    @AuraEnabled
    public static Boolean isSKUValid(String sku) {
        List<Product2> prod = new List<Product2>();
        prod = [SELECT Id, ProductCode FROM Product2 WHERE ProductCode =: sku];
        if(prod.size() > 0){
            return true;
        } else {
            return false;
        }
        
    }
    
    
    /* Get Product hit HH external Database to fetch the product record along with there images and translations */
    public static void getProducts(){
        
        //For Getting token for accessing API
        mulesoftHandler.tokenWrapper token =  mulesoftHandler.getToken();
        
        mulesoftHandler.getCredential();
        
        // Hitting API For fetching Product
        Http protocol = new Http();
        HttpRequest request = new HttpRequest();
        
        system.debug(mulesoftHandler.m_baseUrl + '/accounts/login'	);
        
        //old Endpoint not in use
        // request.setEndpoint(mulesoftHandler.m_baseUrl + '/mocking/api/v1/links/f9558e2a-0c79-432d-b544-0a67c4fa66f4/products');
        //request.setEndpoint(mulesoftHandler.m_baseUrl + '/mocking/api/v1/sources/exchange/assets/41a75cd2-c0e2-4e87-ace1-108af8abd73f/exp-b2bCommerce-web-api/0.2.0/m/products?siteId=fastserver-eu');
        
        request.setEndpoint(mulesoftHandler.m_baseUrl + '/mocking/api/v1/sources/exchange/assets/41a75cd2-c0e2-4e87-ace1-108af8abd73f/exp-b2bCommerce-web-api/0.3.0/m/products?siteId=fastserver-eu');
        request.setMethod('GET');
        request.setHeader('Accept', '*/*'); 
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept-Encoding', 'gzip, deflate, br');
        request.setHeader('Connection', 'keep-alive');
        request.setHeader('client_id' ,'abc');
        request.setHeader('client_secret' ,'abc');    
        request.setTimeout(120000);
        
        //token for API       
        string auth = 'Bearer ';// +token.access_token;
        request.setHeader('Authorization' ,auth); 
        
        // if Error occur save in error message and then create integration_log__c
        string errorMessage = '';
        
        // Database error Count
        integer errorCount = 0;
        
        // Response from API
        HttpResponse response = protocol.send(request );
        System.debug('body22222===='+response.getBody());
        
        string statusCode =  response.getStatus();
        System.debug('code====' +response.getStatusCode() + ' ' + response.getStatusCode() == '200' );
        
        //if error response
        if(response.getStatusCode() != 200 ){
            errorCount ++;
            errorMessage = 'API Failed with Status Code: <b>' + response.getStatusCode() + '</b><br/> <b>Error Body:</b> ' + response.getBody();
        }
        
        if(response.getStatusCode() == 200){
            
            // getting list of manufacturer__c for to making map of manufacture id by name. because API return Name of Manufacturer 
            List<Manufacturer__c> manufacturers = [Select id , Name from Manufacturer__c];
            
            //creating and add Manufacturer id by name
            map <string,id> manufactureIdByName = new map<string,id>();
            
            for(Manufacturer__c manufacturer : manufacturers){
                manufactureIdByName.put(manufacturer.name, manufacturer.id);
            }
            
            
            //desirializing response to object 
            //Object productData = JSON.deserializeUntyped(response.getBody());
            
            //Replacing __c by null because it will raising an error
            string responseStr = response.getBody();//.replaceAll('__c',  '');
            
            //Deserializing response to our wrapper class  
            list<productWrapper> pws  = (list<productWrapper>)JSON.deserialize(responseStr, list<productWrapper>.class);
            
            //list of product to insert 
            List<product2> products = new list<product2>();
            
            // map of wrapperclass by product external id use for inserting images and translation
            map<string,productWrapper> wrapperByProduct = new map<string,productWrapper>();
            
            
            // inserting product to salesforce
            for(productWrapper pw : pws){
                
                // Creating product2 sobject with data by passing wrapper to createproduct method 
                product2 p = createproduct(pw);
                
                // getting manufacturerID by name 
                string ManufacturerID = manufactureIdByName.get(pw.ManufacturerName);
                
                // if no manufacture create one otherwise assign the id 
                if(ManufacturerID == null){
                    Manufacturer__c man = new Manufacturer__c();
                    man.name = pw.ManufacturerName;
                    insert man;
                    ManufacturerID = man.id;
                }
                //assign Id
                p.Manufacturer__c = ManufacturerID;
                
                // converting  image URL to base64 string to save in salesforce
                for(productWrapper.cls_images image: pw.images ){
                    // saving base64 string in productWrapper.cls_images to use it further
                    image.base64= imageUri.getDataUriFromUri(image.url).removeStart('data:image/jpeg;base64,');
                    System.debug('image.base64===='+image.base64);
                }
                //putting wrapper against product external id 
                wrapperByProduct.put(p.ExternalId__c, pw);
                
                //adding product to list
                products.add(p);
            }
            
            //inserting product2 
            list<Database.SaveResult> srList = database.insert( products,false);
            
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else {
                    errorCount ++;
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        ErrorMessage += '<br/>'+ err.getStatusCode() + ': ' + err.getMessage() ;
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
            
            
            
            // list of attachment to be insert
            list<attachment> attachments = new   list<attachment>();
            // list of translation to be insert
            list<Product2DataTranslation> translations = new list<Product2DataTranslation>();
            
            // Map of image by product id to update product with primary image id 
            map<string,attachment> imageByProductId = new map<string,attachment>();
            
            //looping over inserted products to add there images
            for(product2 product : products){
                
                //return if product save unsucessfull
                if(product.id == null)break;
                
                //getting wrapper by external id 
                productWrapper pw =  wrapperByProduct.get(product.ExternalId__c);
                
                //if image null
                if(pw.images == null){
                    system.debug('images not found for '+ product.Name);
                }
                else{
                    //looping over  pw.images
                    for(productWrapper.cls_images image: pw.images ){
                        
                        // uploadImage method return attachment
                        attachment at =  uploadImage(product.id, image.isPrimary, image.Base64, 'testName');
                        //adding attachment to list
                        attachments.add(at);
                        
                        //add only primary image attachment to map to update product.primaryimageid__c
                        if(image.isPrimary == true){
                            imageByProductID.put(product.id,at);
                        }
                    }
                }
                
                //Translation work startted 
                //creating map of productname by localeid 
                Map<string,string> nameByLanguage = new map<string,string>();
                for(productWrapper.cls_Name name: pw.name ){
                    if(name.localeId=='en')continue;
                    nameByLanguage.put(name.localeId,name.value);
                    
                }
                
                
                //creating map of product Description by localeid 
                Map<string,string> nameByDescription = new map<string,string>();
                for(productWrapper.cls_Description name: pw.description ){
                    if(name.localeId=='en')continue;
                    nameByDescription.put(name.localeId,name.value);
                    
                }
                //TranslationHelper.createProductTranslation return list<Product2DataTranslation> of translated name and description
                list<Product2DataTranslation> pdts = TranslationHelper.createProductTranslation(product.Id, nameByLanguage,nameByDescription);
                //adding to list for inserting 
                translations.addAll(pdts);
            }
            
            //inserting traslations and attachments
            insert translations;
            insert attachments;
            
            //updating product with primary image id 
            list<product2> updatableProducts = new list<product2>(); 
            for(string key : imageByProductId.keySet()){
                
                Attachment newImage  = imageByProductId.get(key);
                
                Product2 prd = new product2(
                    id= key,
                    primaryImageId__c =newImage.Id
                );
                
                updatableProducts.add(prd);
            }
            
            update updatableProducts;
        }
        
        //if ErrorMessage has value create a integration log
        if(string.isNotBlank(errorMessage)){
            
            Integration_Log__c il = new Integration_Log__c();
            
            il.API_Name__c = 'product';
            il.errorMessage__c = '<b> Total Number of failed record: </b> '+errorCount + ' <br/> <b> ERROR MESSAGE:</b> <br/> ' +errorMessage;
            
            insert il;
        }
    }
    
    
    static product2  createproduct(productWrapper pw){
        
        product2 product = new product2();
        product.name = getNameBylocale('en',pw.name);
        product.Description = getDescriptionbyLocale('en',pw.description);
        product.ExternalId__c = pw.externalID;
        product.ProductCode = pw.ProductCode;
        product.IsActive = pw.IsActive;
        product.QuantityUnitOfMeasure = pw.QuantityUnitOfMeasure;
        product.InventoryStatus__c = pw.InventoryStatus;
        product.UPC__c = pw.UPC;
        product.Rank__c = pw.Rank;
        product.SalesMultiple__c =pw.SalesMultiple;
        product.ShippingClass__c = pw.ShippingClass;
        //product.ProductClass = pw.ProductClass;
        product.InventoryStatus__c = pw.InventoryStatus;
        Product.Avail__c = pw.Availability;
        
        if(string.isBlank(pw.LastUpdated)==false){
            product.LastUpdated__c = (DateTime)JSON.deserialize('"' + pw.LastUpdated + '"', DateTime.class);
        }
        
        if(string.isBlank(pw.ETA)==false){
            product.ETA__c = (Date)JSON.deserialize('"' + pw.ETA + '"', Date.class);
        }
        
        
        if(String.isBlank(pw.FirstAppearance)==false){
            product.FirstAppearance__c =(DateTime)JSON.deserialize('"' + pw.FirstAppearance + '"', DateTime.class);
        }
        
        if(String.isBlank(pw.LastInStock)==false){
            product.LastInStock__c =  (DateTime)JSON.deserialize('"' + pw.LastInStock + '"', DateTime.class);
        }
        
        return product;
    }
    
    
    static string getNameByLocale(string Lcode,productWrapper.cls_Name[] names){
        
        for(productWrapper.cls_Name name : names){
            
            if(name.localeId == lcode){
                return name.value;
            }
        }
        
        return null;
    }
    
    
    static string getDescriptionByLocale(string Lcode,productWrapper.cls_Description[] Descriptions){
        
        for(productWrapper.cls_Description Description : Descriptions){
            
            if(Description.localeId == lcode){
                return Description.value;
            }
        }
        
        return null;
    }
    
    public class pdpWrapper {
        @AuraEnabled
        public List<PricebookEntry> pricebookEntry {get; set;}
        @AuraEnabled
        public List<Manufacturer__c> manufacturer {get; set;}
        @AuraEnabled
        public Double retailPrice {get; set;}
        @AuraEnabled
        public Double dealerPrice {get; set;}
        @AuraEnabled
        public set<variation> variationRedirect {get; set;}
        @AuraEnabled
        public set<string> variationColor {get; set;}
        public pdpWrapper(){
            variationRedirect = new  set<variation> ();
        }
        public void addVariation(string pid, string color){
            variation v = new variation();
            v.pid = pid;
            v.color = color;
            if(variationRedirect.contains(v) == false){
                variationRedirect.add(v);
            }
        }
        
    }
    class variation
    {
        @AuraEnabled
        public string pid {get; set;}
        @AuraEnabled
        public string Color {get; set;}
    }
    @AuraEnabled
    public static pdpWrapper getProductForPDP(String pid){
        pdpWrapper pdpWrap = new pdpWrapper();
        
        List<PricebookEntry> prod = new List<PricebookEntry>();
        List<Manufacturer__c> m = new List<Manufacturer__c>();
        
        Set<String> priceBookName = new Set<String>();
        priceBookName.add('horizonhobby Price Book');
        priceBookName.add('Dealer Price Book');
        
        prod = [SELECT Id, toLabel(Product2.Name),toLabel(Product2.description),Product2.Color__c, Product2.ProductCode, Product2.ETA__c, Product2.IsActive, product2.Manufacturer__c, UnitPrice, product2.Avail__c, pricebook2.Name FROM PricebookEntry WHERE Product2Id =: pid AND Pricebook2.Name IN: priceBookName ];
        m = [SELECT Id, Logo_Id__c FROM Manufacturer__c WHERE Id =: prod[0].product2.Manufacturer__c];
        
        list<string> nameSplit= prod[0].product2.name.split(',');
        
        PricebookEntry[] prodVariations = new list<PricebookEntry>();
        
        if(nameSplit.size()>0){
            string toMatch = '%' +nameSplit[0]+ '%';
            prodVariations = [SELECT Id, toLabel(Product2.Name),toLabel(Product2.description), Product2.ProductCode, Product2.ETA__c,Product2.color__c, Product2.IsActive, product2.Manufacturer__c, UnitPrice, product2.Avail__c, pricebook2.Name FROM PricebookEntry WHERE Product2.name like :toMatch AND Pricebook2.Name IN: priceBookName];
            
        }
        
        if(prodVariations.size() > 0){
            //int lastIndexofComma = prod[0].product2.name.lastIndexOf(',', 0);
            list<string> nameArray= prod[0].product2.name.split(',');
            // string currentVariant = '' ;
            set<string> variants = new set<string>();
            if(nameArray.size()>0){
                //   currentVariant = nameArray[nameArray.size()-1];
                variants.add(prod[0].Product2.color__c );
                pdpWrap.addVariation(prod[0].product2ID,prod[0].Product2.color__c );
            }
            
            for(PricebookEntry variation :prodVariations){
                string[] nameArray1= variation.product2.name.split(',');
                // string currentVariant1 = '' ;
                if(nameArray1.size()>0){
                    //  currentVariant1 = nameArray1[nameArray1.size()-1];
                    if(variants.contains(variation.Product2.color__c) == false){
                        
                        pdpWrap.addVariation(variation.product2ID,variation.Product2.color__c );
                    }
                    variants.add(variation.Product2.color__c);
                }
            }
            pdpWrap.variationColor = variants;
            
            
        }
        pdpWrap.pricebookEntry = prod;
        pdpWrap.manufacturer = m;
        
        if(prod.size()== 1 ){
            
            pdpWrap.retailPrice = prod[0].pricebook2.Name  == 'horizonhobby Price Book' ? prod[0].UnitPrice: 0;
            pdpWrap.dealerPrice = prod[0].pricebook2.Name  == 'Dealer Price Book'  ? prod[0].UnitPrice: 0;
        }
        else{
            
            pdpWrap.retailPrice = prod[0].pricebook2.Name  == 'horizonhobby Price Book' ? prod[0].UnitPrice: prod[1].UnitPrice;
            pdpWrap.dealerPrice = prod[0].pricebook2.Name  == 'Dealer Price Book'  ? prod[0].UnitPrice: prod[1].UnitPrice;
            
        }
        
        
        return pdpWrap;
    }
    
    @AuraEnabled
    public static PriceAdjustmentTier[] getProductPriceRange(string priceBookid){
        system.debug(priceBookid);
        PricebookEntryAdjustment pea = [SELECT Id, PricebookEntryId, PriceAdjustmentScheduleId FROM PricebookEntryAdjustment where PricebookEntryId = :priceBookid and PriceAdjustmentSchedule.isactive =true limit 1];
        if(pea == null){
            return null;
        }
        system.debug(pea);
        PriceAdjustmentTier[] pat = [SELECT Id, Name, PriceAdjustmentScheduleId, LowerBound, UpperBound, TierType, TierValue FROM PriceAdjustmentTier where PriceAdjustmentScheduleId = :pea.PriceAdjustmentScheduleId];
        system.debug(pat);
        
        return pat;
    }
    
    @AuraEnabled
    public static map<string,string> getTranslations(string langCode){
        map<string,string> translations = new map<string,string>();
        
        if(langCode == 'de'){
            translations = TranslationHelper.getAllGermanTranslation('PDP');
        }
        else if(langCode == 'fr' ){
            translations = TranslationHelper.getAllFrenchTranslation('PDP');
        }
        translations.put('langCode',langCode);
        return translations;
    }
    
    @AuraEnabled
    public static boolean checkDealerPricing(string userId){
        boolean isDealer = false;
        List<User> userRecord = new List<User>();
        userRecord = [SELECT Id, is_Price__c FROM User WHERE Id=:userId];
        if(userRecord.size() > 0){
            isDealer = userRecord[0].is_Price__c;
        }
        
        return isDealer;
    }
    
}