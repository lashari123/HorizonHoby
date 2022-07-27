public with sharing class HomepageTabAuraControllerv2 {
    
    @AuraEnabled
    public static  list<productTableWrapper> getLists(string filter,string noOfRows){
      /*  string query= '';
        string filter1 ='';
        system.debug(filter + ' ' + noOfRows);
        if(filter == null || filter == ''){
            query= 'select toLabel(Name),ProductCode,Family from product2';//  limit '+noOfRows;
        }
        else{
            if(filter == 'newRelease'){
                datetime d = datetime.now();
                d =d.addDays(-30);
                string toString = d.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                filter1+= filter1== ''? 'FirstAppearance__c >= '+toString :' and FirstAppearance__c >= '+toString ;
                system.debug(d);
            }
            else if(filter == 'topSelling'){
                filter1+= filter1== ''? 'AvgDemand__c > 100 ' :' and AvgDemand__c >  100 ' ;
            }
            else if(filter == 'newstocks'){
                datetime d = datetime.now();
                d =d.addDays(-30);
                string toString = d.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                filter1+= filter1== ''? 'lastinstock__c >=  '+toString  :' and lastinstock__c >=  '+toString  ;
                filter1+= ' and Quantity__c >0';
            }
            query= 'select toLabel(Name),ProductCode,Family from product2 where '+filter1;// +'limit '+noOfRows;
        }
        system.debug(query);
        
        system.debug('filter1');
        List<product2> productList = dataBase.query(query);
        system.debug(productList.size());
        system.debug(productList);
        string query2='';
        if(filter == null || filter == ''){
            query2= 'select id, Product2Id,product2.ETA__C, toLabel(Product2.Name),toLabel(Product2.Description), Product2.ProductCode,Product2.stockkeepingunit, UnitPrice,pricebook2.name, IsActive from PricebookEntry where IsActive = true  and (pricebook2.name =\'horizonhobby Price Book\' or pricebook2.name =\'Dealer Price Book\') and  Product2Id IN :productList';
        }
        else{
            if(filter == 'newRelease'){
                
                filter1 = ' AND UnitPrice > 50';
                
            }
            else if(filter == 'topSelling'){
                
                filter1 = ' AND UnitPrice > 50';
            }
            else if(filter == 'newstocks'){
                filter1 = ' AND UnitPrice > 50';
            }
            query2= 'select id, Product2Id,product2.ETA__C, toLabel(Product2.Name),toLabel(Product2.Description), Product2.ProductCode,Product2.stockkeepingunit, UnitPrice,pricebook2.name, IsActive from PricebookEntry where IsActive = true  and (pricebook2.name =\'horizonhobby Price Book\' or pricebook2.name =\'Dealer Price Book\') and  Product2Id IN :productList '+filter1;
            
        }*/
        string Name = '';
        if(filter == 'newstocks')
        {
            name = 'Newly in Stock';
        }
        else if(filter == 'topSelling'){
            
            name = 'Top Selling Items';
        }
        else if(filter == 'newRelease'){
            
            name = 'New Release Items';
        }
        HH_Filter__c filterQ =HHFilterHelper.getFilterbyName(name);
        
        
        string query2 =filterQ.Query_String__c ;
        list<PricebookEntry> PricebookEntryList = database.query(query2);
        system.debug(PricebookEntryList);
        map<string,list<PricebookEntry>> PricebookEntryListByName = new map<string,list<PricebookEntry>>();
        
        
        for (PricebookEntry pbe : PricebookEntryList)
        {
            if(PricebookEntryListByName.get(pbe.Product2Id) == null){
                PricebookEntryListByName.put(pbe.Product2Id,new list<PricebookEntry>());
            }
            PricebookEntryListByName.get(pbe.Product2Id).add(pbe);
            
        } 
        system.debug(PricebookEntryListByName.keyset().size());        
        system.debug(PricebookEntryListByName);
        
        list<productTableWrapper> ptws = new  list<productTableWrapper>();
        integer count = 1;
        for(string key : PricebookEntryListByName.keyset()){
            
            list<PricebookEntry> pbes = PricebookEntryListByName.get(key);
            
            productTableWrapper ptw = new productTableWrapper();
            ptw.name = pbes[0].Product2.Name;
         //   ptw.StockKeepingUnit = pbes[0].Product2.stockkeepingunit;
            if(pbes.size()== 1 ){
                ptw.Retail = pbes[0].pricebook2.Name  == 'horizonhobby Price Book' ? pbes[0].UnitPrice: 0;
                ptw.Dealer = pbes[0].pricebook2.Name  == 'Dealer Price Book'  ? pbes[0].UnitPrice: 0;
            }
            else{
                ptw.Retail = pbes[0].pricebook2.Name  == 'horizonhobby Price Book' ? pbes[0].UnitPrice: pbes[1].UnitPrice;
                ptw.Dealer = pbes[0].pricebook2.Name  == 'Dealer Price Book'  ? pbes[0].UnitPrice: pbes[1].UnitPrice;
            }
            date d = (pbes[0].product2.ETA__C);
            // ptw.ReleaseDate = DateTime.newInstance(d.year(),d.month(),d.day()).format('d-MM-YYYY');
            ptw.product2Id = pbes[0].product2Id;
            ptw.description = pbes[0].product2.Description;
            ptws.add(ptw);
            if(count == integer.valueOf(noOfRows)){
                break;
            }
            count++;
        }
        system.debug(ptws);
        system.debug(ptws.size());
        return ptws;
    }
    @AuraEnabled
    public static map<string,string> getLabels(){
        
        map<string,string> productMap =  TranslationHelper.getLabelsBySobjectName('product2');
        map<string,string> PricebookEntryMap =  TranslationHelper.getLabelsBySobjectName('PricebookEntry');
        
        productMap.putAll(PricebookEntryMap);
        return productMap;
        
    }
    
    @AuraEnabled
    public static map<string,string> getTranslations(string langCode){
        map<string,string> translations = new map<string,string>();
        
        if(langCode == 'de'){
            translations = TranslationHelper.getAllGermanTranslation('Home');
        }
        else if(langCode == 'fr' ){
            translations = TranslationHelper.getAllFrenchTranslation('Home');
        }
        translations.put('langCode',langCode);
        return translations;
    }
    
    @AuraEnabled
    public static boolean isPrice(string userId){
        system.debug(userId);
        
        //   PermissionSetAssignment psa = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment where PermissionSet.Name = 'Enable_list_price' and AssigneeId = :myAssigneeId limit 1];
        user u = [select id ,is_price__c from user where id = :userId];
        return u.is_price__c;     
    }

	@auraEnabled
    public static string getFilterIdByName(string name){
        return [SELECT id from HH_Filter__c where name = :name ].Id;
    }

    
    
}