public class HeaderController {
    @AuraEnabled
    public static String setLanguagetoDefault() {
        if (!Cache.Session.contains('LanguageChecked')) {
            Cache.Session.put('LanguageChecked', 'C');
            String check = LanguageController.setDefaultLanguage();
            return check;
        }else{
            return null;
        }
        /*Cookie LanguageChecked = ApexPages.currentPage().getCookies().get('LanguageChecked');
        if (LanguageChecked == null) {
            String checked = 'true';
            //Cookie LanguageChecked2 = new Cookie('LanguageChecked',checked,null,-1,false);
            //ApexPages.currentPage().setCookies(new Cookie[]{LanguageChecked2});
           // LanguageController.setDefaultLanguage();
        }*/
    }
     @AuraEnabled(cacheable=true)
    public static HH_Filter__c[] getFilterList(){
        return HHFilterHelper.getMenuFilter();
    }
    
    @AuraEnabled
    public static resultWrapper getMonthlySales(){
        
        User userRec  = [Select Id,Name, Email, ContactId from User where Id=:  UserInfo.getUserId()];
        
        string contactId= userRec.ContactId;
        Contact contactRec = [Select Id,Name, AccountId from Contact where Id=: contactId];
        
        string AccountId=contactRec.AccountId;
        
        Date todayDate= date.today();
        system.debug(todayDate);
        Integer month = todayDate.month();
        Integer year = todayDate.year();
        system.debug(month);
        system.debug(year);
        
        Date invoiceDateStart= Date.newInstance(year, month, 1);
        Date invoiceDateEnd= Date.newInstance(year, month+1, 1);
        
        system.debug( invoiceDateEnd);
        
        
        List<Invoice__c> invoiceList = [Select Id,Name, Amount__c,Invoice_Date__c,Order__c,Status__c	 from Invoice__c
                                        where order__r.accountid=:AccountId //'0016t000002fWfCAAU' //test  business account of tkhan@horizonhobby.com contact
                                        and Invoice_Date__c>=:invoiceDateStart and Invoice_Date__c<: invoiceDateEnd
                                       ];
        
        Decimal totalMonthlySale=0;
        
        for(Invoice__c inv: invoiceList){
            if(inv.Amount__c!=null){
                totalMonthlySale=totalMonthlySale+inv.Amount__c;
            }
        }
        
        system.debug('monthly sale:::'+totalMonthlySale);
        
        //Get Dealer Monthly Target/Goal:
        
        List<Dealer_Monthly_Goal__c> monthlyTarget= [Select Id,Name, Account__c, Dealer_Account_Number__c,Goal__c,Period__c
                                                     from Dealer_Monthly_Goal__c where Account__c=:'0016t000002fWfCAAU' and
                                                     Period__c=:invoiceDateStart limit 1];
        
        String monthlySaleColor='Red';
        
        if(monthlyTarget.size()>0){
            Decimal thisMonthTarget= monthlyTarget[0].goal__c;
            system.debug('this Month target:::'+thisMonthTarget);
            if(thisMonthTarget!=null){
                if(totalMonthlySale < thisMonthTarget){
                    monthlySaleColor='Red';
                }
                else if(totalMonthlySale >=thisMonthTarget){
                    monthlySaleColor='Green';
                }
            }
        }
        
        system.debug('Color:::'+monthlySaleColor);
        
        resultWrapper wrapper = new resultWrapper();
        wrapper.MonthlySale=totalMonthlySale;
        wrapper.SaleColor=monthlySaleColor;
        
        return wrapper;
    }
    
    public class resultWrapper{
        
        @AuraEnabled
        public  decimal MonthlySale {get;set;}
        @AuraEnabled
        public  string SaleColor {get;set;}
        
    }


}