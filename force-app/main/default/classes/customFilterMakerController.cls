public with sharing class customFilterMakerController {
    
    @auraEnabled
    Public static string saveFilter(string Name ,string QueryFilter,string parseString,string recordID){
        queryFilter =' PricebookEntry.IsActive = true and ' + queryFilter +' ';
        string tempValue = QueryFilter;
        integer orIndex = tempValue.indexOf('OR');// > 0 ? tempValue.indexOf('OR') : tempValue.indexOf('or');
        
        if(orIndex>0){
            
            list<string> mergeList = new list<string>();
            list<string> templist = tempValue.split('OR');
            
            for(string temp : templist){
                temp = '(' + temp +')';
                
                mergeList.add(temp);
            }
            QueryFilter = String.join( mergeList, ' OR ' );
        }
        system.debug(queryFilter);
        string query = 'select id, Product2Id,product2.LastUpdated__c,pricebook2.Name,product2.LastInStock__c,product2.Avail__c,product2.InventoryStatus__c ,Product2.PrimaryImageID__c,toLabel(Product2.Name),toLabel(Product2.Description), Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,IsActive from PricebookEntry where ';
        query += QueryFilter;
        
        
        HH_Filter__c filter = new HH_Filter__c(id =recordID, name = Name , Query_String__c = query,parsingString__c = parseString);
        
        try{
            database.UpsertResult results = database.upsert( filter);
            
            if(results.isSuccess() == false){
                list<database.Error> errors = results.getErrors();
                for(Database.Error err : errors) {
                    System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                    System.debug('fields that affected this error: ' + err.getFields());
                    
                }
            }
        }
        catch(DmlException ex){
            return 'error';
        }
        
        return filter.ID;
        
    } 
    
    @auraEnabled(cacheable=true)
    Public static list<PricebookEntry> getFilteredData(string QueryFilter){
        queryFilter =' PricebookEntry.IsActive = true and ' + queryFilter +' ';
        string tempValue = QueryFilter;
        integer orIndex = tempValue.indexOf('OR');// > 0 ? tempValue.indexOf('OR') : tempValue.indexOf('or');
        
        if(orIndex>0){
            
            list<string> mergeList = new list<string>();
            list<string> templist = tempValue.split('OR');
            
            for(string temp : templist){
                temp = '(' + temp +')';
                
                mergeList.add(temp);
            }
            QueryFilter = String.join( mergeList, ' OR ' );
        }
        system.debug(queryFilter);
        string pricebook = 'horizonhobby Price Book';
        string query = 'select id, Product2Id,pricebook2.Name,product2.LastUpdated__c,product2.Avail__c,product2.LastInStock__c,product2.promocode__c ,Product2.PrimaryImageID__c,toLabel(Product2.Name),toLabel(Product2.Description), Product2.ProductCode, UnitPrice,product2.ETA__c,product2.UPC__c,product2.Rank__c,product2.ShippingClass__c,product2.Quantity__c,IsActive,product2.FirstAppearance__c from PricebookEntry where ';
        query += QueryFilter;
        query += 'AND pricebook2.Name = :priceBook'; 
        
        list<PricebookEntry> pbe =  database.query(query);
        
        return pbe; 
        
    } 
    
    @auraEnabled(cacheable= true)
    public static HH_Filter__c getParsingValue(string filterId)
    {
        return HHFilterHelper.getFilter(filterId);
    }
    
    
}