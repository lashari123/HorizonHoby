public with sharing  class TranslationHelper {
    @auraEnabled
    Public static map<string,string> getAllGermanTranslation(string groupBy){
        
        groupBy = '%'+ groupBy+'%';
        list<translation__c> translations = [Select Name, German__c from Translation__c where German__c != null and Group__c like :groupBy];
        
        
        map<string,string> translationByName = new  map<string,string> ();
        
        for ( translation__c translation : translations){
            translationByName.put(translation.name,translation.German__c);
            
        }
        System.debug(translationByName);
        return translationByName;
    }
    
     @auraEnabled
    Public static map<string,string> getAllFrenchTranslation(string groupBy){
        
        groupBy = '%'+ groupBy+'%';
        list<translation__c> translations = [Select Name, French__c from Translation__c where French__c != null and Group__c like :groupBy];
        
        
        map<string,string> translationByName = new  map<string,string> ();
        
        for ( translation__c translation : translations){
            translationByName.put(translation.name,translation.French__c);
            
        }
        System.debug(translationByName);
        return translationByName;
    }
    
    
    
    @auraEnabled(cacheable=true)
    Public static String getUserLanguage(){
        System.debug(UserInfo.getLanguage());
        System.debug(UserInfo.getUserId());
        
        return UserInfo.getLanguage();
    }
    
    @auraEnabled(cacheable=true)
    Public static map<string,string> getLabelsBySobjectName(string sObjectName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(sObjectName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
         map<string,string>  translationByApiName = new  map<string,string> ();
        for (String fieldName: fieldMap.keySet()) {
            
         //   System.debug('##Field API Name='+fieldName);// list of all field API name
            
            
            
           string label =  fieldMap.get(fieldName).getDescribe().getLabel();//It provides to get the object fields label.
             System.debug('##Field  label='+label);// 
            translationByApiName.put(fieldName,label);
        }
        return  translationByApiName;
    }
    
    public static list<Product2DataTranslation> createProductTranslation(string productId, Map<string,string> nameData,Map<string,string> descriptionData){
        
        list<Product2DataTranslation> translatedData = new list<Product2DataTranslation>();
        for(string key : nameData.keySet()){
            Product2DataTranslation pdt = new Product2DataTranslation();
            pdt.parentId = productId;
            pdt.Name = nameData.get(key);
            pdt.Description = descriptionData.get(key);
            pdt.Language = key;
            translatedData.add(pdt);
        }
        return translatedData;
        
    } 
    
}