public class filterHelper {

    @auraEnabled
    public static List<String> retrieveFields(String sObjectName){
        // Object Name whose fields we have to retrieve
        List<String> objFields = new list<string>();
        
        
        Map<String , Schema.SObjectType> schemaGlobalDescription = Schema.getGlobalDescribe();
        Schema.sObjectType objType = schemaGlobalDescription.get(sObjectName); 
        Schema.DescribeSObjectResult objDescribeSObjectResult = objType.getDescribe(); 
        Map<String , Schema.SObjectField> mapFieldList = objDescribeSObjectResult.fields.getMap();  
        for(Schema.SObjectField field : mapFieldList.values())  
        {  
            Schema.DescribeFieldResult fieldResult = field.getDescribe(); 
            // isAccessible () Returns true if the current user can see this object, false otherwise
            if(fieldResult.isAccessible() && fieldResult.getName().contains('__pc') == false)
                objFields.add(fieldResult.getName());
        }
        
        return objFields;
    }
    
    //Wrapper class that is being used to contain all the filter's checkbox values for category filter page side bar
     public class FilterCheckboxWrapper{
         @AuraEnabled
       	 public List<ProductCategory> prodCat{get;set;}
         @AuraEnabled
       	 public List<Object> prodCatFiltered{get;set;}
         @AuraEnabled
       	 public List<Manufacturer__c> manufacturers{get;set;}
         @AuraEnabled
       	 public List<String> priceBracket{get;set;}
         @AuraEnabled
       	 public List<String> scaleWrapper{get;set;}
         @AuraEnabled
       	 public List<String> skillLevelWrapper{get;set;}
         @AuraEnabled
       	 public List<String> powerTypeWrapper{get;set;}
         @AuraEnabled
       	 public List<String> statusWrapper{get;set;}
         @AuraEnabled
       	 public List<String> vehicleTypeWrapper{get;set;}
         @AuraEnabled
       	 public List<String> completionLevelWrapper{get;set;}
     }
    
    public class FilteredCheckboxWrapper{
         @AuraEnabled
       	 public List<String> prodCatFiltered{get;set;}
         @AuraEnabled
       	 public List<String> manufacturersFiltered{get;set;}
         @AuraEnabled
       	 public List<String> priceBracket{get;set;}
         @AuraEnabled
       	 public List<String> scaleWrapper{get;set;}
         @AuraEnabled
       	 public List<String> skillLevelWrapper{get;set;}
         @AuraEnabled
       	 public List<String> powerTypeWrapper{get;set;}
         @AuraEnabled
       	 public List<String> statusWrapper{get;set;}
         @AuraEnabled
       	 public List<String> vehicleTypeWrapper{get;set;}
         @AuraEnabled
       	 public List<String> completionLevelWrapper{get;set;}
     }

    
    @AuraEnabled
    public static FilteredCheckboxWrapper getFilteredCheckboxValues(List<String> prodList){
        FilteredCheckboxWrapper fcw = new FilteredCheckboxWrapper();
        Integer size = 6;
        //Fetching Category Checkbox Values and Count
        Map<ID, ProductCategory> PC = new Map<ID, ProductCategory>([SELECT id, Name FROM ProductCategory WHERE CatalogId = '0ZS6t0000000006GAA']);
        Set<String> prodIds = new Set<String>(prodList);
        //List<Object> catIdFil = new List<Object>();
        AggregateResult[] catIdFil = [select count(id)co, ProductCategoryId from ProductCategoryProduct WHERE ProductCategory.CatalogId = '0ZS6t0000000006GAA' and ProductId IN: prodIds group by ProductCategoryId Limit: size];
        List<String> catOutput = new List<String>();
        for(AggregateResult pcp : catIdFil){
            
            String pdId =(String) pcp.get('ProductCategoryId');
            ProductCategory pCat = PC.get(pdId);
            Integer count = (Integer) pcp.get('co');
            String cnt = String.valueOf(count);
            String cOut = pCat.Id + '_' + pCat.Name + ' (' +cnt + ')';
            catOutput.add(cOut);
        }
        fcw.prodCatFiltered = catOutput;
        //fcw.prodCat = [SELECT id, Name, CatalogId FROM ProductCategory WHERE CatalogId = '0ZS6t0000000006GAA' and id IN: catId];
        
         
        //Fetching Manufacturers Checkbox Values and Count
        Map<ID, Manufacturer__c> man = new Map<ID, Manufacturer__c>([SELECT Id, Name from Manufacturer__c]);
        AggregateResult[] manAgg =[select count(Manufacturer__r.name)co, Manufacturer__c from product2 where Id IN: prodList  group by Manufacturer__c Limit: size];
        List<String> manOutput = new List<String>();
        system.debug('test1:::');
        for(AggregateResult ma : manAgg){
            
            String mId =(String) ma.get('Manufacturer__c');
            if(mId != null){
                system.debug('test2:::' + mId);
                Manufacturer__c manu = man.get(mId);
                system.debug('test3:::' + manu.Id);
                Integer count = (Integer) ma.get('co');
                String cnt = String.valueOf(count);
                String mOut = manu.Id + '_' + manu.Name + ' (' +cnt + ')';
                manOutput.add(mOut);
            }
            
        }
        system.debug('test4:::');
        fcw.manufacturersFiltered = manOutput;
        
        //Fetching Retail Prices Checkbox Values and Count
        AggregateResult[] rtAgg =[select count(Id)co, Retail_Price_Bracket__c  from product2 where Id IN: prodList  group by Retail_Price_Bracket__c Limit: size];
        List<String> rtOutput = new List<String>();
        for(AggregateResult rt : rtAgg){
            
            String rtValue =(String) rt.get('Retail_Price_Bracket__c');
            if(rtValue != null && rtValue != ''){
                Integer count = (Integer) rt.get('co');
                String cnt = String.valueOf(count);
                String rtOut = rtValue + '_' + rtValue + ' (' +cnt + ')';
                rtOutput.add(rtOut);
            }
        }
        fcw.priceBracket = rtOutput;
        
        //Fetching Completion Level Checkbox Values and Count
        AggregateResult[] clAgg =[select count(Id)co, Completion_Level__c from product2 where Id IN: prodList group by Completion_Level__c Limit: size];
        List<String> clOutput = new List<String>();
        for(AggregateResult ar : clAgg){
            
            String Value =(String) ar.get('Completion_Level__c');
            if(Value != null && Value != ''){
                Integer count = (Integer) ar.get('co');
                String cnt = String.valueOf(count);
                String Out = Value + '_' + Value + ' (' +cnt + ')';
                clOutput.add(Out);
            }
        }
        fcw.completionLevelWrapper = clOutput;
        
        //Fetching Scale Checkbox Values and Count
        AggregateResult[] sAgg =[select count(Id)co, Scale__c from product2 where Id IN: prodList group by Scale__c Limit: size];
        List<String> sOutput = new List<String>();
        for(AggregateResult ar : sAgg){
            
            String Value =(String) ar.get('Scale__c');
            if(Value != null && Value != ''){
                Integer count = (Integer) ar.get('co');
                String cnt = String.valueOf(count);
                String Out = Value + '_' + Value + ' (' +cnt + ')';
                sOutput.add(Out);
            }
        }
        fcw.scaleWrapper = sOutput;
        
        //Fetching Skill Level Values and Count
        AggregateResult[] slAgg =[select count(Id)co, Skill_Level__c from product2 where Id IN: prodList group by Skill_Level__c Limit: size];
        List<String> slOutput = new List<String>();
        for(AggregateResult ar : slAgg){
            
            String Value =(String) ar.get('Skill_Level__c');
            if(Value != null && Value != ''){
                Integer count = (Integer) ar.get('co');
                String cnt = String.valueOf(count);
                String Out = Value + '_' + Value + ' (' +cnt + ')';
                slOutput.add(Out);
            }
        }
        fcw.skillLevelWrapper = slOutput;
        
        //Fetching Power Type Values and Count
        AggregateResult[] ptAgg =[select count(Id)co, Power_Type__c from product2 where Id IN: prodList group by Power_Type__c Limit: size];
        List<String> ptOutput = new List<String>();
        for(AggregateResult ar : ptAgg){
            
            String Value =(String) ar.get('Power_Type__c');
            if(Value != null && Value != ''){
                Integer count = (Integer) ar.get('co');
                String cnt = String.valueOf(count);
                String Out = Value + '_' + Value + ' (' +cnt + ')';
                ptOutput.add(Out);
            }
        }
        fcw.powerTypeWrapper = ptOutput;
        
        //Fetching Status Values and Count
        AggregateResult[] stAgg =[select count(Id)co, InventoryStatus__c from product2 where Id IN: prodList group by InventoryStatus__c Limit: size];
        List<String> stOutput = new List<String>();
        for(AggregateResult ar : stAgg){
            
            String Value =(String) ar.get('InventoryStatus__c');
            if(Value != null && Value != ''){
                Integer count = (Integer) ar.get('co');
                String cnt = String.valueOf(count);
                String Out = Value + '_' + Value + ' (' +cnt + ')';
                stOutput.add(Out);
            }
        }
        fcw.statusWrapper = stOutput;
        
        //Fetching Vehicle Type Values and Count
        AggregateResult[] vtAgg =[select count(Id)co, Vehicle_Type__c from product2 where Id IN: prodList group by Vehicle_Type__c Limit: size];
        List<String> vtOutput = new List<String>();
        for(AggregateResult ar : vtAgg){
            
            String Value =(String) ar.get('Vehicle_Type__c');
            if(Value != null && Value != ''){
                Integer count = (Integer) ar.get('co');
                String cnt = String.valueOf(count);
                String Out = Value + '_' + Value + ' (' +cnt + ')';
                vtOutput.add(Out);
            }
        }
        fcw.vehicleTypeWrapper = vtOutput;
        
        
        return fcw;
    }
    
    //Gets all the filter's picklist values displayed on category filter page
    @AuraEnabled
    public static FilterCheckboxWrapper getFilterCheckboxValues(){
        FilterCheckboxWrapper fcw = new FilterCheckboxWrapper();
        
        //Fetching Category Checkbox Values
        fcw.prodCat = [select id, Name, CatalogId from ProductCategory where CatalogId = '0ZS6t0000000006GAA' limit 5];
        
        
        
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get('Product2');
        Schema.DescribeSObjectResult res = convertToObj.getDescribe(); 
        //Getting Retail Price Checkbox Values
        List<String> RetailPickListValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get('Retail_Price_Bracket__c').getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Integer i=0;
        for( Schema.PicklistEntry pickListVal : ple){
            if(i==5) break;
            RetailPickListValues.add(pickListVal.getLabel());
            i++;
        }
        fcw.priceBracket = RetailPickListValues;
        
        //Getting Completion Level Checkbox Values
        List<String> completionLevelValues = new List<String>();
        Schema.DescribeFieldResult fieldResult2 = res.fields.getMap().get('Completion_Level__c').getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        i=0;
        for( Schema.PicklistEntry pickListVal : ple2){
            if(i==5) break;
            completionLevelValues.add(pickListVal.getLabel());
            i++;
        }
        fcw.completionLevelWrapper = completionLevelValues;
        
        //Getting Scale Checkbox Values
        List<String> scalePickListValues = new List<String>();
        Schema.DescribeFieldResult fieldResult3 = res.fields.getMap().get('Scale__c').getDescribe();
        List<Schema.PicklistEntry> ple3 = fieldResult3.getPicklistValues();
        i=0;
        for( Schema.PicklistEntry pickListVal : ple3){
            if(i==5) break;
            scalePickListValues.add(pickListVal.getLabel());
            i++;
        }
        fcw.scaleWrapper = scalePickListValues;
        
        //Getting Skill Level Checkbox Values
        List<String> skillLevelPickListValues = new List<String>();
        Schema.DescribeFieldResult fieldResult4 = res.fields.getMap().get('Skill_Level__c').getDescribe();
        List<Schema.PicklistEntry> ple4 = fieldResult4.getPicklistValues();
        i=0;
        for( Schema.PicklistEntry pickListVal : ple4){
            if(i==5) break;
            skillLevelPickListValues.add(pickListVal.getLabel());
            i++;
        }
        fcw.skillLevelWrapper = skillLevelPickListValues;
        
        //Getting Power Type Checkbox Values
        List<String> powerTypePickListValues = new List<String>();
        Schema.DescribeFieldResult fieldResult5 = res.fields.getMap().get('Power_Type__c').getDescribe();
        List<Schema.PicklistEntry> ple5 = fieldResult5.getPicklistValues();
        i=0;
        for( Schema.PicklistEntry pickListVal : ple5){
            if(i==5) break;
            powerTypePickListValues.add(pickListVal.getLabel());
            i++;
        }
        fcw.powerTypeWrapper = powerTypePickListValues;
        
        //Getting Status Checkbox Values
        List<String> statusPickListValues = new List<String>();
        Schema.DescribeFieldResult fieldResult6 = res.fields.getMap().get('InventoryStatus__c').getDescribe();
        List<Schema.PicklistEntry> ple6 = fieldResult6.getPicklistValues();
        i=0;
        for( Schema.PicklistEntry pickListVal : ple6){
            if(i==5) break;
            statusPickListValues.add(pickListVal.getLabel());
            i++;
        }
        fcw.statusWrapper = statusPickListValues;
        
        //Getting Vehicle Type Checkbox Values
        List<String> vehicleTypePickListValues = new List<String>();
        Schema.DescribeFieldResult fieldResult7 = res.fields.getMap().get('Vehicle_Type__c').getDescribe();
        List<Schema.PicklistEntry> ple7 = fieldResult7.getPicklistValues();
        i=0;
        for( Schema.PicklistEntry pickListVal : ple7){
            if(i==5) break;
            vehicleTypePickListValues.add(pickListVal.getLabel());
            i++;
        }
        fcw.vehicleTypeWrapper = vehicleTypePickListValues;
        
        //Getting Manufacturer Checkbox Values
        fcw.manufacturers = [select id, Name from Manufacturer__c limit 5];
        
        
        return fcw;
    }
    
    @AuraEnabled
    public static List<ProductCategory> getCategories(Integer size){
        //select ProductCategoryId, COUNT(ProductId) from ProductCategoryProduct where ProductCategory.CatalogId = '0ZS6t0000000006GAA' GROUP BY ProductCategoryId
        List<ProductCategory> categoryList = new List<ProductCategory>();
        categoryList = [SELECT id, Name, CatalogId FROM ProductCategory WHERE CatalogId = '0ZS6t0000000006GAA' LIMIT: size];
        
        return categoryList;
    }
    
    @AuraEnabled
    public static List<String> getFilteredCategories(Integer size, List<String> prodList){
        size = size++;
        //Fetching Category Checkbox Values and Count
        Map<ID, ProductCategory> PC = new Map<ID, ProductCategory>([SELECT id, Name FROM ProductCategory WHERE CatalogId = '0ZS6t0000000006GAA']);
        Set<String> prodIds = new Set<String>(prodList);
        //List<Object> catIdFil = new List<Object>();
        AggregateResult[] catIdFil = [select count(id)co, ProductCategoryId from ProductCategoryProduct WHERE ProductCategory.CatalogId = '0ZS6t0000000006GAA' and ProductId IN: prodIds group by ProductCategoryId Limit: size];
        List<String> catOutput = new List<String>();
        for(AggregateResult pcp : catIdFil){
            
            String pdId =(String) pcp.get('ProductCategoryId');
            ProductCategory pCat = PC.get(pdId);
            Integer count = (Integer) pcp.get('co');
            String cnt = String.valueOf(count);
            String cOut = pCat.Id + '_' + pCat.Name + ' (' +cnt + ')';
            catOutput.add(cOut);
        }
        return catOutput;
    }
    
    @AuraEnabled
    public static List<Manufacturer__c> getManufacturers(Integer size){
        List<Manufacturer__c> manufacturerList = new List<Manufacturer__c>();
        manufacturerList = [SELECT id, Name FROM Manufacturer__c lIMIT: size];
        
        return manufacturerList;
    }
    
    @AuraEnabled
    public static List<String> getFilteredManufacturers(Integer size, List<String> prodList){
        size = size++;
        //Fetching Manufacturers Checkbox Values and Count
        Map<ID, Manufacturer__c> man = new Map<ID, Manufacturer__c>([SELECT Id, Name from Manufacturer__c]);
        AggregateResult[] manAgg =[select count(Manufacturer__r.name)co, Manufacturer__c from product2 where Id IN: prodList  group by Manufacturer__c Limit: size];
        List<String> manOutput = new List<String>();
        system.debug('test1:::');
        for(AggregateResult ma : manAgg){
            
            String mId =(String) ma.get('Manufacturer__c');
            if(mId != null){
                system.debug('test2:::' + mId);
                Manufacturer__c manu = man.get(mId);
                system.debug('test3:::' + manu.Id);
                Integer count = (Integer) ma.get('co');
                String cnt = String.valueOf(count);
                String mOut = manu.Id + '_' + manu.Name + ' (' +cnt + ')';
                manOutput.add(mOut);
            }
            
        }
        return manOutput;
    }
    
    @AuraEnabled
    public static List<String> getRetailPrices(Integer size){
        List<String> RetailPickListValues = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get('Product2');
        Schema.DescribeSObjectResult res = convertToObj.getDescribe(); 
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get('Retail_Price_Bracket__c').getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Integer i=0;
        for( Schema.PicklistEntry pickListVal : ple){
            if(i==size) break;
            RetailPickListValues.add(pickListVal.getLabel());
            i++;
        }
        
        return RetailPickListValues;
    }
    
    @AuraEnabled
    public static List<String> getFilteredRetailPrices(Integer size, List<String> prodList){
        size = size++;
        //Fetching Retail Prices Checkbox Values and Count
        AggregateResult[] rtAgg =[select count(Id)co, Retail_Price_Bracket__c  from product2 where Id IN: prodList  group by Retail_Price_Bracket__c Limit: 5];
        List<String> rtOutput = new List<String>();
        for(AggregateResult rt : rtAgg){
            
            String rtValue =(String) rt.get('Retail_Price_Bracket__c');
            if(rtValue != null && rtValue != ''){
                Integer count = (Integer) rt.get('co');
                String cnt = String.valueOf(count);
                String rtOut = rtValue + '_' + rtValue + ' (' +cnt + ')';
                rtOutput.add(rtOut);
            }
        }
        return rtOutput;
    }
    
    @AuraEnabled
    public static List<String> getCompletionLevels(Integer size){
        List<String> CompletionLevelsValues = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get('Product2');
        Schema.DescribeSObjectResult res = convertToObj.getDescribe(); 
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get('Completion_Level__c').getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Integer i=0;
        for( Schema.PicklistEntry pickListVal : ple){
            if(i==size) break;
            CompletionLevelsValues.add(pickListVal.getLabel());
            i++;
        }
        
        return CompletionLevelsValues;
    }
    
    @AuraEnabled
    public static List<String> getFilteredCompletionLevels(Integer size, List<String> prodList){
        size = size++;
        //Fetching Completion Level Checkbox Values and Count
        AggregateResult[] clAgg =[select count(Id)co, Completion_Level__c from product2 where Id IN: prodList group by Completion_Level__c Limit: 5];
        List<String> clOutput = new List<String>();
        for(AggregateResult ar : clAgg){
            
            String Value =(String) ar.get('Completion_Level__c');
            if(Value != null && Value != ''){
                Integer count = (Integer) ar.get('co');
                String cnt = String.valueOf(count);
                String Out = Value + '_' + Value + ' (' +cnt + ')';
                clOutput.add(Out);
            }
        }
        return clOutput;
    }
    
    @AuraEnabled
    public static List<String> getScales(Integer size){
        List<String> ScalesPickListValues = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get('Product2');
        Schema.DescribeSObjectResult res = convertToObj.getDescribe(); 
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get('Scale__c').getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Integer i=0;
        for( Schema.PicklistEntry pickListVal : ple){
            if(i==size) break;
            ScalesPickListValues.add(pickListVal.getLabel());
            i++;
        }
        
        return ScalesPickListValues;
    }
    
    @AuraEnabled
    public static List<String> getFilteredScales(Integer size, List<String> prodList){
        size = size++;
        //Fetching Scale Checkbox Values and Count
        AggregateResult[] sAgg =[select count(Id)co, Scale__c from product2 where Id IN: prodList group by Scale__c Limit: 5];
        List<String> sOutput = new List<String>();
        for(AggregateResult ar : sAgg){
            
            String Value =(String) ar.get('Scale__c');
            if(Value != null && Value != ''){
                Integer count = (Integer) ar.get('co');
                String cnt = String.valueOf(count);
                String Out = Value + '_' + Value + ' (' +cnt + ')';
                sOutput.add(Out);
            }
        }
        return sOutput;
    }
    
    @AuraEnabled
    public static List<String> getPowerTypes(Integer size){
        List<String> PowerTypesPickListValues = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get('Product2');
        Schema.DescribeSObjectResult res = convertToObj.getDescribe(); 
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get('Power_Type__c').getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Integer i=0;
        for( Schema.PicklistEntry pickListVal : ple){
            if(i==size) break;
            PowerTypesPickListValues.add(pickListVal.getLabel());
            i++;
        }
        
        return PowerTypesPickListValues;
    }
    
    @AuraEnabled
    public static List<String> getFilteredPowerTypes(Integer size, List<String> prodList){
        size = size++;
        //Fetching Power Type Values and Count
        AggregateResult[] ptAgg =[select count(Id)co, Power_Type__c from product2 where Id IN: prodList group by Power_Type__c Limit: 5];
        List<String> ptOutput = new List<String>();
        for(AggregateResult ar : ptAgg){
            
            String Value =(String) ar.get('Power_Type__c');
            if(Value != null && Value != ''){
                Integer count = (Integer) ar.get('co');
                String cnt = String.valueOf(count);
                String Out = Value + '_' + Value + ' (' +cnt + ')';
                ptOutput.add(Out);
            }
        }
        return ptOutput;
    }

    
    @AuraEnabled
    public static List<String> getVehicleTypes(Integer size){
        List<String> VehicleTypePickListValues = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get('Product2');
        Schema.DescribeSObjectResult res = convertToObj.getDescribe(); 
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get('Vehicle_Type__c').getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Integer i=0;
        for( Schema.PicklistEntry pickListVal : ple){
            if(i==size) break;
            VehicleTypePickListValues.add(pickListVal.getLabel());
            i++;
        }
        
        return VehicleTypePickListValues;
    }
    
    @AuraEnabled
    public static List<String> getFilteredVehicleTypes(Integer size, List<String> prodList){
        size = size++;
        //Fetching Vehicle Type Values and Count
        AggregateResult[] vtAgg =[select count(Id)co, Vehicle_Type__c from product2 where Id IN: prodList group by Vehicle_Type__c Limit: 5];
        List<String> vtOutput = new List<String>();
        for(AggregateResult ar : vtAgg){
            
            String Value =(String) ar.get('Vehicle_Type__c');
            if(Value != null && Value != ''){
                Integer count = (Integer) ar.get('co');
                String cnt = String.valueOf(count);
                String Out = Value + '_' + Value + ' (' +cnt + ')';
                vtOutput.add(Out);
            }
        }
        return vtOutput;
    }
}