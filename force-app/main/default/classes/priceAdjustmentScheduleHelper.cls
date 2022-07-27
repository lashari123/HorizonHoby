public class priceAdjustmentScheduleHelper {
    
    public static void getPriceBook(){
        string JSONSampleString = '[{"attributes":{"type":"PricebookEntry"},"PricebookId":"HEU-21","ProductId":"ACU1232","UnitPrice":1058.82,"IsActive":true,"ActivePriceAdjustmentQuantity":1,"mmCode__c":null},{"attributes":{"type":"PricebookEntry"},"PricebookId":"HEU-21","ProductId":"ARA4303V3","UnitPrice":1058.82,"IsActive":true,"ActivePriceAdjustmentQuantity":1,"mmCode__c":null},{"attributes":{"type":"PricebookEntry"},"PricebookId":"HEU-21","ProductId":"ARA4303V3","UnitPrice":1008.82,"IsActive":true,"ActivePriceAdjustmentQuantity":6,"mmCode__c":"asdf1234"},{"attributes":{"type":"PricebookEntry"},"PricebookId":"HEU-21","ProductId":"ARA4303V3","UnitPrice":998.82,"IsActive":true,"ActivePriceAdjustmentQuantity":12,"mmCode__c":"asdf1234"},{"attributes":{"type":"PricebookEntry"},"PricebookId":"HEU-21","ProductId":"ACU1232","UnitPrice":1008.82,"IsActive":true,"ActivePriceAdjustmentQuantity":10,"mmCode__c":null}]';
        JSONSampleString = JSONSampleString.replaceAll('__c', '');
        List<priceAdjustmentScheduleHelper.PASWrapper> jsonSerialize = (List<priceAdjustmentScheduleHelper.PASWrapper>) JSON.deserializeStrict(JSONSampleString, List<priceAdjustmentScheduleHelper.PASWrapper>.class); 
        
        set<string> jsonProductsExId = new set<string>();
        
        //looping on json to get all productIds
        for(priceAdjustmentScheduleHelper.PASWrapper PricebookEntry :jsonSerialize){
            jsonProductsExId.add(PricebookEntry.ProductId);
        }
        
        //getting all products in Giving json(API) 
        Product2[] products =[Select id,name,externalid__c from product2 where externalid__c in :jsonProductsExId];
        map<string,Product2> productByExternalId = new  map<string,Product2>();
        for(Product2 product : products){
            productByExternalId.put(Product.externalid__c, product);
        }
        
        //Getting all pricebooks 
        Pricebook2[] pbs =[Select id,externalid__c from Pricebook2];
        map<string,Pricebook2> pbByExternalId = new  map<string,Pricebook2>();
        for(Pricebook2 pb : pbs){
            pbByExternalId.put(pb.externalid__c, pb);
        }
        
        //looping through pricebookentry to check if standard pricebook exist on current product;
        List<PricebookEntry> standardPricebookEntries = [Select id,pricebook2id,product2Id from pricebookEntry where pricebook2.isStandard = true and product2Id in :products ];
        set<string> productWithStandardPricebook = new set<string>();
        for(PricebookEntry pbe : standardPricebookEntries){
            productWithStandardPricebook.add(pbe.Product2Id);
        }
        string standardPricebookId = standardPricebookEntries[0].pricebook2id;
        
        map<string,List<priceAdjustmentScheduleHelper.PASWrapper>> variationList = new map<string,List<priceAdjustmentScheduleHelper.PASWrapper>>();
        list<PricebookEntry> pbestoInsert = new list<PricebookEntry>(); 
        //list<PriceAdjustmentSchedule> pastoInsert = new list<PriceAdjustmentSchedule>(); 
        map<string,PriceAdjustmentSchedule> mapOfinsertPAS = new map<string,PriceAdjustmentSchedule>(); 
        map<string,PricebookEntry> mapOfinsertPBE = new map<string,PricebookEntry>(); 
        
        integer i =0;
        for(priceAdjustmentScheduleHelper.PASWrapper pricebookentry :jsonSerialize){
            if(pricebookentry.ActivePriceAdjustmentQuantity == 1){
                if(productWithStandardPricebook.contains(productByExternalId.get(pricebookentry.ProductId).id)== false){
                    PricebookEntry pbe = new pricebookEntry();
                    pbe.Pricebook2Id = standardPricebookId;
                    pbe.Product2Id = productByExternalId.get(pricebookentry.ProductId).id;
                    pbe.UnitPrice = pricebookentry.UnitPrice;
                  //mapOfinsertPBE.put(pricebookentry.PricebookId + pricebookEntry.ProductId,pbe);
                    insert pbe;

                }
                PricebookEntry pbe = new pricebookEntry();
                pbe.Pricebook2Id = pbByExternalId.get(pricebookentry.PricebookId).id;
                pbe.Product2Id = productByExternalId.get(pricebookentry.ProductId).id;
                pbe.UnitPrice = pricebookentry.UnitPrice;
                mapOfinsertPBE.put(pricebookentry.PricebookId + pricebookEntry.ProductId,pbe);
                /*  if(jsonSerialize.size() > i+1){

PriceAdjustmentSchedule pAS = new  PriceAdjustmentSchedule();
pas.name = productByExternalId.get(pricebookentry.ProductId).Name;
pas.AdjustmentMethod = 'Range';
mapOfinsertPAS.put( pricebookentry.PricebookId + pricebookEntry.ProductId,pas);
//pasId= pas.Id;
}*/
            }
            else{
                if(variationList.get(pricebookentry.PricebookId + pricebookEntry.ProductId ) == null){
                    variationList.put(pricebookentry.PricebookId + pricebookEntry.ProductId , new List<priceAdjustmentScheduleHelper.PASWrapper>()) ;
                }
                variationList.get(pricebookentry.PricebookId + pricebookEntry.ProductId ).add(pricebookentry);
                
                
            } 
            i++;
        }
        system.debug(variationList);
        insert mapOfinsertPBE.values();
        
        for(string key : variationList.keySet() ){
            
            priceAdjustmentScheduleHelper.PASWrapper pricebookentry = variationlist.get(key)[0];
            PriceAdjustmentSchedule pAS = new  PriceAdjustmentSchedule();
            pas.name = productByExternalId.get(pricebookentry.ProductId).Name;
            pas.AdjustmentMethod = 'Range';
            mapOfinsertPAS.put( pricebookentry.PricebookId + pricebookEntry.ProductId,pas);
        
        }
        insert mapOfinsertPAS.values();
        
        list<PriceAdjustmentTier> PATs = new list<PriceAdjustmentTier>();
        list<PricebookEntryAdjustment> PEAs = new list<PricebookEntryAdjustment>();
        for(string key :variationList.keyset()){
            PricebookEntryAdjustment pEA = new PricebookEntryAdjustment();
            pEA.PricebookEntryId = mapOfinsertPBE.get(key).id;
            pEA.PriceAdjustmentScheduleId = mapOfinsertPAS.get(key).id;
            
            peas.add(pea);
            integer j =0;
            for(priceAdjustmentScheduleHelper.PASWrapper pricebookentry :variationList.get(key)){
                
                PriceAdjustmentTier pAT = new PriceAdjustmentTier();
                system.debug('key :: '+ key);
                system.debug('mapOfinsertPAS :: '+ mapOfinsertPAS);
                pAT.PriceAdjustmentScheduleId  = mapOfinsertPAS.get(key).id;
                pAT.LowerBound = double.valueOf(pricebookentry.ActivePriceAdjustmentQuantity);
                pAT.tierType ='AdjustmentAmount';
                system.debug(variationList.get(key).size() +' ----------------------------- '+ (j+1));
                if(variationList.get(key).size() == j+1){
                    //  pAT.UpperBound = '';
                }
                else{
                    pAT.UpperBound = double.valueOf(variationList.get(key)[j+1].ActivePriceAdjustmentQuantity)-1; 
                }
                pAT.tierValue = pricebookentry.UnitPrice;
                PATs.add( pat);
                j++;
                
            }
            
        }
        insert PATs;
        insert PEAs;
    }
    public class PASWrapper{
        
        public String Id;
        public cls_attributes attributes;
        public String PricebookId;	//HEU-21
        public String ProductId;	//LOS05014V2T2
        public Double UnitPrice;	//1058.82
        public boolean IsActive;
        public Integer ActivePriceAdjustmentQuantity;	//1
        public String mmCode;	//qw
        
    }
    class cls_attributes {
        public String type;	//PricebookEntry
    }
}