public with sharing class storeListViewHandler {
    
    @AuraEnabled 
    public static String getHtmlFile(string HtmlText) {
        return EncodingUtil.base64Encode(Blob.valueOf(htmlText));
    }
    
    @AuraEnabled 
    public static boolean isDealerPricing() {
        return [Select id , is_price__c from user where id = :userInfo.getUserId()].is_price__c;
    }
    
    @AuraEnabled
    public static map<string,string> getTranslations(string langCode){
        map<string,string> translations = new map<string,string>();
        if(langCode == 'de'){
            translations = TranslationHelper.getAllGermanTranslation('Search');
        }
        else if(langCode == 'fr' ){
            translations = TranslationHelper.getAllFrenchTranslation('Search');
        }
        translations.put('langCode',langCode);
        return translations;
    }
    
    @AuraEnabled
    public static List<PricebookEntry> getList(string type){
        
        List<PricebookEntry> productList = new List<PricebookEntry>();
        
        if(type == 'New Releases'){
            //according to type
            Set<String> prodids = new Set<String>();
            
            
            for(ProductCategoryProduct prodCatProd : [select id, ProductCategoryId, ProductId from ProductCategoryProduct where ProductCategory.CatalogId = '0ZS6t0000000006GAA']) {
                prodids.add(prodCatProd.ProductId);
            }
            productList = [select id, Product2Id, toLabel(Product2.Name),toLabel(Product2.Description),Product2.PrimaryImageID__c, Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive from PricebookEntry where IsActive = true ];
            
            
            List<PricebookEntry> productList2 = new List<PricebookEntry>();
            Map<id, productSearchWrapper>  pMap= new Map<id, productSearchWrapper>();
            for(PricebookEntry pbe : productList){
                productSearchWrapper pSW = new productSearchWrapper(pbe); 
                
                if(pMap.get(psw.ID) == null){
                    pMap.put(psw.ID, psw);
                    productList2.add(pbe);
                    
                }
                else{
                    
                    if(pMap.get(psw.ID).UnitPrice== 0  &&pMap.get(psw.ID).UnitPrice < psw.UnitPrice ){
                        pMap.put(psw.ID, psw);
                        productList2.add(pbe);
                        
                    }
                }
            }
            
            return productList2;
        }
        
        
        return productList;
        
        
        
    }
    
    @AuraEnabled
    public static List<product2> getLists(string filter,string noOfRows){
        
        system.debug(filter + ' ' + noOfRows);
        string query= 'select toLabel(Name),ProductCode,Family from product2 where '+filter +'limit '+noOfRows;
        List<product2> productList = dataBase.query(query);
        
        return productList;
        
        
        
    }
    
    @AuraEnabled
    public static String [] generateListForProducts(list<object> products) {
        String [] prodList = new list<String>();
        for(object prd : products){
            map<object,object> t= ( map<object,object>)prd;
            
            String pid =(string)t.get('ProductCode');
            Integer Quantity =Integer.valueOf(t.get('Quantity'));
            String prod = pid + '_' + Quantity;
            
            prodList.add(prod);
        }
        return prodList;
    }
    
    @AuraEnabled
    public static id addToCart(list<object> products,list<id> productsId) {
        User userContact = [Select Contact.Accountid from User where Id =:userInfo.getUserId() limit 1 ];
        webCart cartCurrent = [Select id,accountid from webcart where status = 'Active' and AccountID = :userContact.Contact.Accountid order by createdDate Desc limit 1];
        CartDeliveryGroup cDG = [SELECT id FROM CartDeliveryGroup where cartId = :cartCurrent.Id limit 1];
        list<cartItem> items = new list<cartItem>();
        
        system.debug(products);
        Map<id, productSearchWrapper>  psws = getDetails(productsId);
        for(object prd : products){
            
            map<object,object> t= ( map<object,object>)prd;
            
            id pid =(string)t.get('Product2Id');
            system.debug(pid);
            productSearchWrapper psw =  psws.get(pid);
            cartItem item = new cartItem();
            item.Product2Id =pid;
            item.Quantity =(double)t.get('Quantity');
            item.TotalPrice = psw.UnitPrice*item.Quantity;
            item.CartDeliveryGroupId = cDG.Id;
            item.Type = 'Product';
            item.Name = psw.ProductName;
            item.CartId = cartCurrent.ID;
            item.UnitAdjustedPrice =psw.UnitPrice;
            items.add(item);
        }
        
        insert(items);
        return cartCurrent.ID;
        
    }
    @AuraEnabled
    public static List<ProductCategory> getCategories(){
        List<ProductCategory> categoryList = new List<ProductCategory>();
        categoryList = [select id, Name, CatalogId from ProductCategory where CatalogId = '0ZS6t0000000006GAA'];
        
        return categoryList;
    }
    
    
    //Getting list of product for search Table
    @AuraEnabled
    public static list<productTableWrapper> getProductList(List<String> recIds, Integer caseNo,string keyword, string filterID){
        
        
        List<PricebookEntry> productList = new List<PricebookEntry>();
        
        Set<String> prodids = new Set<String>();
        system.debug(string.isNotBlank(keyword));
        system.debug(UserInfo.getLanguage() != 'en_US');
        
        // search keyword -- if language not equal to english translation work;
        if(string.isNotBlank(keyword) && UserInfo.getLanguage() != 'en_US'){
            
            
            string term = '%'+keyword+'%';
            list<Product2DataTranslation> translatedData = [SELECT Additional_Details__c, Id, Parent.name, Language, Name, Description FROM Product2DataTranslation where name like :term and language = :UserInfo.getLanguage()];
            string tempkeyword =''; 
            
            if(translatedData.size()>0){
                
                // getting english name 
                tempkeyword = translatedData[0].parent.Name;
                
                /*
* 	getting smallest name from the list to filter
* for example if keyword == flug and tempKeyword == flugzeug II but the database has smaller value 
* eg: flugzeug than tmp keyword is replace by smaller word
*/
                for(Product2DataTranslation translatedString : translatedData){
                    if(tempkeyword.length()>translatedString.Parent.Name.length()){
                        tempkeyword = translatedString.Parent.Name ;
                    }
                }
            }
            
            // if tempkeyword is null the keyword will not change
            keyword = string.isBlank(tempkeyword) ?keyword : tempkeyword;
        }
        /*
* case 0 = only keyword
* case 1 = category != null manufacture != null keyword is optional
* case 2 = category == null manufacture != null keyword is optional
* case 3 = category != null manufacture == null keyword is optional
*/
        switch on caseNo {
            
            when 0 {
                
                if(string.isNotBlank(keyword)){
                    
                    string term = '%'+keyword+'%';
                    
                    string query = 'select id, Product2Id,pricebook2.Name,product2.LastUpdated__c,product2.Avail__c,product2.InventoryStatus__c ,Product2.PrimaryImageID__c,toLabel(Product2.Name),toLabel(Product2.Description), Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive from PricebookEntry where IsActive = true';
                    query += ' and (Product2.Name like :term OR product2.productCode like :term)'; 
                    query+= ' ORDER BY product2.inventorystatus__c DESC'; 
                    system.debug(query);
                    
                    productList = database.query(query);
                }
                if(  string.isBlank(keyword) && string.isBlank(filterID)){
                    
                    ProductCategory  radioId = [SELECT Id, Name FROM ProductCategory where name = 'Radios' limit 1];
                    //getting searched category productIDs
                    for(ProductCategoryProduct prodCatProd : [select id, ProductCategoryId, ProductId from ProductCategoryProduct where  ProductCategoryId != :radioId.id And ProductCategory.ParentCategoryId  != :radioId.id]) {
                        prodids.add(prodCatProd.ProductId);
                    }
                    
                    string query = 'select id,Product2Id,pricebook2.Name,product2.LastUpdated__c,product2.Avail__c,product2.InventoryStatus__c ,Product2.PrimaryImageID__c,toLabel(Product2.Name),toLabel(Product2.Description), Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive from PricebookEntry where IsActive = true  and (pricebook2.name =\'horizonhobby Price Book\' or pricebook2.name =\'Dealer Price Book\')'
                        +'and  product2.AvgDemand__c > 100 and product2.avail__c = \'Y\'   AND UnitPrice > 50 AND Product2.Manufacturer__r.Name !=\'RFL\' ';
                    productList = database.query(query);
                }
            }
            
            when 1 {
                Set<String> catId = new Set<String>();
                Set<String> manId = new Set<String>();
                Set<String> retPrice = new Set<String>();
                Set<String> comLevel = new Set<String>();
                Set<String> sc = new Set<String>();
                Set<String> skillLev = new Set<String>();
                Set<String> poTyp = new Set<String>();
                Set<String> st = new Set<String>();
                Set<String> veTyp = new Set<String>();
                for(String Id : recIds){
                    if(Id.split('_')[0] == 'categories'){
                        catId.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'manufacturers'){
                        manId.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'retailPrices'){
                        retPrice.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'completionLevel'){
                        comLevel.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'scale'){
                        sc.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'skillLevel'){
                        skillLev.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'powerType'){
                        poTyp.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'status'){
                        st.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'vehicleType'){
                        veTyp.add(Id.split('_')[1]);
                    }
                }
                //getting searched category productIDs
                for(ProductCategoryProduct prodCatProd : [select id, ProductCategoryId, ProductId from ProductCategoryProduct where ProductCategory.CatalogId = '0ZS6t0000000006GAA' and ProductCategoryId IN : catId ]) {
                    prodids.add(prodCatProd.ProductId);
                }
                
                // manufacture Id
                //string ManuID =  recIds[1];
                
                string query = 'select id, Product2Id,pricebook2.Name,product2.LastUpdated__c,product2.Avail__c,product2.InventoryStatus__c ,Product2.PrimaryImageID__c,toLabel(Product2.Name),toLabel(Product2.Description), Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive from PricebookEntry where IsActive = true and Product2Id IN :prodids';
                
                if(manId.size() > 0){
                    query += ' and (Product2.Manufacturer__c IN :manId)';
                }
                
                if(retPrice.size() > 0){
                    query += ' and (Product2.Retail_Price_Bracket__c IN :retPrice)';
                }
                
                if(comLevel.size() > 0){
                    query += ' and (Product2.Completion_Level__c IN :comLevel)';
                }
                
                if(sc.size() > 0){
                    query += ' and (Product2.Scale__c IN :sc)';
                }
                
                if(skillLev.size() > 0){
                    query += ' and (Product2.Skill_Level__c IN :skillLev)';
                }
                
                if(poTyp.size() > 0){
                    query += ' and (Product2.Power_Type__c IN :poTyp)';
                }
                
                if(st.size() > 0){
                    query += ' and (Product2.InventoryStatus__c IN :st)';
                }
                
                if(veTyp.size() > 0){
                    query += ' and (Product2.Vehicle_Type__c IN :veTyp)';
                }
                
                if(string.isNotBlank(keyword)){
                    
                    string term = '%'+keyword+'%';
                    query += ' and (Product2.Name like :term OR product2.productCode like :term)'; 
                    system.debug(query);
                } 
                
                query+= ' ORDER BY product2.inventorystatus__c DESC';
                
                productList = database.query(query);
            }
            
            when 2 {
                
                Set<String> manId = new Set<String>();
                Set<String> retPrice = new Set<String>();
                Set<String> comLevel = new Set<String>();
                Set<String> sc = new Set<String>();
                Set<String> skillLev = new Set<String>();
                Set<String> poTyp = new Set<String>();
                Set<String> st = new Set<String>();
                Set<String> veTyp = new Set<String>();
                
                for(String Id : recIds){
                    if(Id.split('_')[0] == 'manufacturers'){
                        manId.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'retailPrices'){
                        retPrice.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'completionLevel'){
                        comLevel.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'scale'){
                        sc.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'skillLevel'){
                        skillLev.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'powerType'){
                        poTyp.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'status'){
                        st.add(Id.split('_')[1]);
                    } else if(Id.split('_')[0] == 'vehicleType'){
                        veTyp.add(Id.split('_')[1]);
                    }
                }
                
               // string ManuID =  recIds[0];
                
                string query = 'select id, Product2Id,pricebook2.Name,product2.LastUpdated__c,product2.Avail__c,product2.InventoryStatus__c ,Product2.PrimaryImageID__c,toLabel(Product2.Name),toLabel(Product2.Description), Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive from PricebookEntry where IsActive = true';
                
                if(manId.size() > 0){
                    query += ' and (Product2.Manufacturer__c IN :manId)';
                }
                
                if(retPrice.size() > 0){
                    query += ' and (Product2.Retail_Price_Bracket__c IN :retPrice)';
                }
                
                if(comLevel.size() > 0){
                    query += ' and (Product2.Completion_Level__c IN :comLevel)';
                }
                
                if(sc.size() > 0){
                    query += ' and (Product2.Scale__c IN :sc)';
                }
                
                if(skillLev.size() > 0){
                    query += ' and (Product2.Skill_Level__c IN :skillLev)';
                }
                
                if(poTyp.size() > 0){
                    query += ' and (Product2.Power_Type__c IN :poTyp)';
                }
                
                if(st.size() > 0){
                    query += ' and (Product2.InventoryStatus__c IN :st)';
                }
                
                if(veTyp.size() > 0){
                    query += ' and (Product2.Vehicle_Type__c IN :veTyp)';
                }
                
                if(string.isNotBlank(keyword)){
                    string term = '%'+keyword+'%';
                    query += ' and (Product2.Name like :term OR product2.productCode like :term)'; 
                    system.debug(query);
                }
                
                query+= ' ORDER BY product2.inventorystatus__c DESC'; 
                
                productList = database.query(query);
            }
            
            when 3 {
                
                Set<String> catId = new Set<String>();
                for(String Id : recIds){
                    if(Id.split('_')[0] == 'categories'){
                        catId.add(Id.split('_')[1]);
                    }
                }
                
                for(ProductCategoryProduct prodCatProd : [select id, ProductCategoryId, ProductId from ProductCategoryProduct where ProductCategory.CatalogId = '0ZS6t0000000006GAA' and ProductCategoryId IN : catId ]) {
                    prodids.add(prodCatProd.ProductId);
                }
                
                string query = 'select id, Product2Id,pricebook2.Name,product2.LastUpdated__c,product2.Avail__c,product2.InventoryStatus__c ,Product2.PrimaryImageID__c,toLabel(Product2.Name),toLabel(Product2.Description), Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive from PricebookEntry where IsActive = true and Product2Id IN :prodids';
                
                if(string.isNotBlank(keyword)){
                    string term = '%'+keyword+'%';
                    query += ' and (Product2.Name like :term OR product2.productCode like :term)';
                    system.debug(query);
                }
                
                query+= ' ORDER BY product2.inventorystatus__c DESC';
                
                productList = database.query(query);
                system.debug(query);                
                // productList = [select id, Product2Id,pricebook2.Name,product2.LastUpdated__c,product2.Avail__c,product2.InventoryStatus__c ,Product2.PrimaryImageID__c,Product2.Name, Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive from PricebookEntry where Product2Id IN: prodids and IsActive = true];
            }
            
           
        }
        if(string.isNotBlank( filterID)){
            
            Set<String> catId = new Set<String>();
            Set<String> manId = new Set<String>();
            Set<String> retPrice = new Set<String>();
            Set<String> comLevel = new Set<String>();
            Set<String> sc = new Set<String>();
            Set<String> skillLev = new Set<String>();
            Set<String> poTyp = new Set<String>();
            Set<String> st = new Set<String>();
            Set<String> veTyp = new Set<String>();
            for(String Id : recIds){
                if(Id.split('_')[0] == 'categories'){
                    catId.add(Id.split('_')[1]);
                } else if(Id.split('_')[0] == 'manufacturers'){
                    manId.add(Id.split('_')[1]);
                } else if(Id.split('_')[0] == 'retailPrices'){
                    retPrice.add(Id.split('_')[1]);
                } else if(Id.split('_')[0] == 'completionLevel'){
                    comLevel.add(Id.split('_')[1]);
                } else if(Id.split('_')[0] == 'scale'){
                    sc.add(Id.split('_')[1]);
                } else if(Id.split('_')[0] == 'skillLevel'){
                    skillLev.add(Id.split('_')[1]);
                } else if(Id.split('_')[0] == 'powerType'){
                    poTyp.add(Id.split('_')[1]);
                } else if(Id.split('_')[0] == 'status'){
                    st.add(Id.split('_')[1]);
                } else if(Id.split('_')[0] == 'vehicleType'){
                    veTyp.add(Id.split('_')[1]);
                }
            }
            
            if(catId.size() > 0){
                    for(ProductCategoryProduct prodCatProd : [select id, ProductCategoryId, ProductId from ProductCategoryProduct where ProductCategory.CatalogId = '0ZS6t0000000006GAA' and ProductCategoryId IN : catId ]) {
                    prodids.add(prodCatProd.ProductId);
                }
                }
            
             string query = HHFilterHelper.getFilter(filterId).Query_String__c;
            
            if(catId.size() > 0){
                query += ' and (Product2Id IN :prodids)';
            }
            
            if(manId.size() > 0){
                    query += ' and (Product2.Manufacturer__c IN :manId)';
                }
                
                if(retPrice.size() > 0){
                    query += ' and (Product2.Retail_Price_Bracket__c IN :retPrice)';
                }
                
                if(comLevel.size() > 0){
                    query += ' and (Product2.Completion_Level__c IN :comLevel)';
                }
                
                if(sc.size() > 0){
                    query += ' and (Product2.Scale__c IN :sc)';
                }
                
                if(skillLev.size() > 0){
                    query += ' and (Product2.Skill_Level__c IN :skillLev)';
                }
                
                if(poTyp.size() > 0){
                    query += ' and (Product2.Power_Type__c IN :poTyp)';
                }
                
                if(st.size() > 0){
                    query += ' and (Product2.InventoryStatus__c IN :st)';
                }
                
                if(veTyp.size() > 0){
                    query += ' and (Product2.Vehicle_Type__c IN :veTyp)';
                }
            
            productList = database.query(query);
          
        }
        
    
        system.debug(productList);
        
        //for auto sort outof stock and discontinued item
        List<PricebookEntry> ossDiscProductList = new List<PricebookEntry>();
        
        // for remaining Item
        List<PricebookEntry> tempProductList = new List<PricebookEntry>();
        
        //populate above to list
        for (PricebookEntry pbe : productList)
        { 
            if(string.isNotBlank( pbe.Product2.inventoryStatus__c)){
                if(pbe.Product2.inventoryStatus__c.toLowerCase() == 'disc' || pbe.Product2.Avail__c == 'N'){
                    ossDiscProductList.add(pbe);
                    //integer index = productList.indexOf(pbe);
                    // productList.remove(index);
                }
                else{
                    
                    tempProductList.add(pbe);
                }
            }
            else{
                
                tempProductList.add(pbe);
            }
        }
        
        //adding both again to productlist oss and Disc at the end
        productList = new List<PricebookEntry>();
        
        productList.addAll(tempProductList);
        productList.addAll(ossDiscProductList);
        
        
        //Map for retail and dealer pricing 
        map<string,list<PricebookEntry>> PricebookEntryListByName = new map<string,list<PricebookEntry>>();
        
        // adding prices by pricebook name two show retailer and dealer seperately
        for (PricebookEntry pbe : productList)
        {
            
            if(PricebookEntryListByName.get(pbe.Product2Id) == null){
                
                PricebookEntryListByName.put(pbe.Product2Id,new list<PricebookEntry>());
            }
            
            PricebookEntryListByName.get(pbe.Product2Id).add(pbe);
        } 
        
        system.debug(PricebookEntryListByName.keyset().size());        
        system.debug(PricebookEntryListByName);
        
        // for cstegory column of search table 
        List<ProductCategoryProduct> pcps = [SELECT Id, productid,Product.name, IsPrimaryCategory, CatalogId, ProductToCategory, ProductCategory.Name FROM ProductCategoryProduct where isPrimaryCategory = true and Productid in :PricebookEntryListByName.keyset()];
        
        //category name by product id 
        map<string,string> categoriesByProductId = new map<string,string>();
        
        for(ProductCategoryProduct pcp : pcps){
            
            categoriesByProductId.put(pcp.productId,pcp.ProductCategory.Name);
        }
        
        // search table wrapper class 
        list<productTableWrapper> ptws = new  list<productTableWrapper>();
        
        integer count = 1;
        
        for(string key : PricebookEntryListByName.keyset()){
            
            // getting pricebooks by id
            list<PricebookEntry> pbes = PricebookEntryListByName.get(key);
            
            // add product to wrapper
            productTableWrapper ptw = new productTableWrapper();
            ptw.name = pbes[0].Product2.Name;
            
            //ptw.StockKeepingUnit = pbes[0].Product2.stockkeepingunit;
            
            // adding retail and dealer prices 
            if(pbes.size()== 1 ){
                
                ptw.Retail = pbes[0].pricebook2.Name  == 'horizonhobby Price Book' ? pbes[0].UnitPrice: 0;
                ptw.Dealer = pbes[0].pricebook2.Name  == 'Dealer Price Book'  ? pbes[0].UnitPrice: 0;
            }
            else{
                
                ptw.Retail = pbes[0].pricebook2.Name  == 'horizonhobby Price Book' ? pbes[0].UnitPrice: pbes[1].UnitPrice;
                ptw.Dealer = pbes[0].pricebook2.Name  == 'Dealer Price Book'  ? pbes[0].UnitPrice: pbes[1].UnitPrice;
                ptw.pbe = pbes[0].pricebook2.Name  == 'Dealer Price Book'  ? pbes[0]: pbes[1];
           
            }
            
            // mapping other fields
            date d = (pbes[0].product2.ETA__C);
            ptw.product2Id = pbes[0].product2Id;
            ptw.description = pbes[0].product2.Description;
            
            // getting category by product id
            ptw.category = categoriesByProductId.get(pbes[0].product2.Id);
            
            ptws.add(ptw);
            
        }
        system.debug(ptws);
        system.debug(ptws.size());
        return ptws;
        
        /*    List<PricebookEntry> productList2 = new List<PricebookEntry>();
Map<id, productSearchWrapper>  pMap= new Map<id, productSearchWrapper>();
for(PricebookEntry pbe : productList){


productSearchWrapper pSW = new productSearchWrapper(pbe); 

if(pMap.get(psw.ID) == null){
pMap.put(psw.ID, psw);
productList2.add(pbe);

}
else{

if(pMap.get(psw.ID).UnitPrice== 0  &&pMap.get(psw.ID).UnitPrice < psw.UnitPrice ){
pMap.put(psw.ID, psw);
productList2.add(pbe);

}
}
}

return productList2;*/
        
        
        
    }
    
    /* @AuraEnabled
public static  List<PricebookEntry> getProductList(String catId){
List<PricebookEntry> productList = new List<PricebookEntry>();
Set<String> prodids = new Set<String>();

for(ProductCategoryProduct prodCatProd : [select id, ProductCategoryId, ProductId from ProductCategoryProduct where ProductCategory.CatalogId = '0ZS6t0000000006GAA' and ProductCategoryId = : catId ]) {
prodids.add(prodCatProd.ProductId);
}


productList = [select id, Product2Id, Product2.Name, Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive from PricebookEntry where Product2Id IN: prodids and IsActive = true ORDER BY UnitPrice ASC];

List<PricebookEntry> productList2 = new List<PricebookEntry>();
Map<id, productSearchWrapper>  pMap= new Map<id, productSearchWrapper>();
for(PricebookEntry pbe : productList){
productSearchWrapper pSW = new productSearchWrapper(pbe); 

if(pMap.get(psw.ID) == null){
pMap.put(psw.ID, psw);
productList2.add(pbe);

}
else{

if(pMap.get(psw.ID).UnitPrice== 0  &&pMap.get(psw.ID).UnitPrice < psw.UnitPrice ){
pMap.put(psw.ID, psw);
productList2.add(pbe);

}
}
}

return productList2;
}*/
    
    
    static Map<id, productSearchWrapper>  getDetails(list<id> productids){
        list<PricebookEntry> productList =   [select id, Product2Id, Product2.Name,Product2.Description, Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive,product2.PrimaryImageID__c from PricebookEntry where Product2Id = :productids and IsActive = true ORDER BY UnitPrice ASC];
        Map<id, productSearchWrapper>  pMap= new Map<id, productSearchWrapper>();
        for(PricebookEntry pbe : productList){
            productSearchWrapper pSW = new productSearchWrapper(pbe); 
            
            if(pMap.get(psw.ID) == null){
                pMap.put(psw.ID, psw);
                
            }
            else{
                
                if(pMap.get(psw.ID).UnitPrice== 0  &&pMap.get(psw.ID).UnitPrice < psw.UnitPrice ){
                    pMap.put(psw.ID, psw);
                    
                }
            }
            
        }
        return pMap;
    } 
    @AuraEnabled
    public static List<Manufacturer__c> getManufacturers(){
        List<Manufacturer__c> manufacturerList =  [select id, Name from Manufacturer__c];
        
        return manufacturerList;
    }
    class productSearchWrapper{
        public string Id;
        public string ProductName;
        public string ProductCode;
        public decimal UnitPrice;
        public string PrimaryImageLink;
        
        public string Description;
        
        
        public productSearchWrapper(PricebookEntry pbe){
            
            id = pbe.Product2Id;
            ProductName = pbe.Product2.Name;
            ProductCode = pbe.Product2.ProductCode;
            UnitPrice= pbe.UnitPrice;
            PrimaryImageLink = 'servlet/servlet.FileDownload?file='+pbe.Product2.PrimaryImageID__c;
            description = pbe.Product2.Description;
        }
        
    }
    
}