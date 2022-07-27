public class LanguageController {
    
    @AuraEnabled
    public static void changeLanguage(String Language){
        User user = new User();
        user = [select id, name, LanguageLocaleKey, username from User where id =: Userinfo.getUserid()];
                
        if(Language == 'Eng'){
            user.LanguageLocaleKey = 'en_US';
            update user;
        } else if(Language == 'Ger'){
            user.LanguageLocaleKey = 'de';
            update user;
        } else if(Language == 'Fre'){
            user.LanguageLocaleKey = 'fr';
            update user;
        }
    }
    
    @AuraEnabled
    public static void changeDefaultLanguage(String Language){
        User user = new User();
        user = [select id, name, LanguageLocaleKey, username, DefaultLanguage__c from User where id =: Userinfo.getUserid()];
                
        if(Language == 'Eng'){
            user.DefaultLanguage__c = 'en_US';
            update user;
        } else if(Language == 'Ger'){
            user.DefaultLanguage__c = 'de';
            update user;
        } else if(Language == 'Fre'){
            user.DefaultLanguage__c = 'fr';
            update user;
        }
    }
    
    @AuraEnabled
    public static String getCurrentLanguage(){
        User user = new User();
        user = [select id, name, LanguageLocaleKey, username from User where id =: Userinfo.getUserid()];
                
        if(user.LanguageLocaleKey == 'en_US'){
            return 'en';
        } else if(user.LanguageLocaleKey == 'de'){
            return 'de';
        } else if(user.LanguageLocaleKey == 'fr'){
            return 'fr';
        } else{
            return 'en';
        }
    }
    
    @AuraEnabled
    public static map<string,string> getTranslations(string langCode){
        map<string,string> translations = new map<string,string>();
        
        if(langCode == 'Ger'){
            translations = TranslationHelper.getAllGermanTranslation('Header');
        }
        else if(langCode == 'Fre' ){
            translations = TranslationHelper.getAllFrenchTranslation('Header');
        }
        translations.put('langCode',langCode);
        return translations;
    }
    
    /*
     * Assigns the user language same as default at the time of Login
     */ 
    @AuraEnabled
    public static String setDefaultLanguage(){
        User user = new User();
        user = [select id, name, LanguageLocaleKey, username, DefaultLanguage__c from User where id =: Userinfo.getUserid()];
        system.debug('After Login2:::');
        if(user.LanguageLocaleKey != user.DefaultLanguage__c){
            system.debug('After Login3:::');
            user.LanguageLocaleKey = user.DefaultLanguage__c;
            update user;
            return 'changed';
        } else {
            return 'not changed';
        }
    }

}