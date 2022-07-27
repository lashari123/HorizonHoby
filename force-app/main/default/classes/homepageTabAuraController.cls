public with sharing class homepageTabAuraController {
    
    @AuraEnabled
    public static  list<productTableWrapper> getLists(string filter,string noOfRows){
        
        system.debug(filter + ' ' + noOfRows);
        string query= 'select toLabel(Name),ProductCode,Family from product2 where '+filter +'limit '+noOfRows;
        
        List<product2> productList = dataBase.query(query);
        
        list<PricebookEntry> PricebookEntryList = [select id, Product2Id, toLabel(Product2.Name), Product2.ProductCode,Product2.stockkeepingunit, UnitPrice,pricebook2.name, IsActive from PricebookEntry where IsActive = true  and (pricebook2.name ='horizonhobby Price Book' or pricebook2.name ='Dealer Price Book') and  Product2Id IN :productList ];
        
        map<string,list<PricebookEntry>> PricebookEntryListByName = new map<string,list<PricebookEntry>>();
        
        for (PricebookEntry pbe : PricebookEntryList)
        {
            if(PricebookEntryListByName.get(pbe.pricebook2.name) == null){
                PricebookEntryListByName.put(pbe.pricebook2.name,new list<PricebookEntry>());
            }
            PricebookEntryListByName.get(pbe.pricebook2.name).add(pbe);
            
        }
        
        list<productTableWrapper> ptws = new  list<productTableWrapper>();
        for(string key : PricebookEntryListByName.keyset()){
            
            list<PricebookEntry> pbes = PricebookEntryListByName.get(key);
            
            productTableWrapper ptw = new productTableWrapper();
            ptw.name = pbes[0].Product2.Name;
            ptw.StockKeepingUnit = pbes[0].Product2.stockkeepingunit;
            ptw.Retail = pbes[0].pricebook2.Name == 'horizonhobby Price Book' ? pbes[0].UnitPrice: pbes[1].UnitPrice;
            ptw.Dealer = pbes[0].pricebook2.Name == 'Dealer Price Book' ? pbes[0].UnitPrice: pbes[1].UnitPrice;
            ptw.ReleaseDate = 'early december';
            ptw.product2Id = pbes[0].product2Id;
            ptws.add(ptw);
        }
        system.debug(ptws);
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
        translations.put('langCode',langCode);
        return translations;
    }
    

    
}