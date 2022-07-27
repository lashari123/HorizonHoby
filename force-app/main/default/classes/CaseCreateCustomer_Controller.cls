public class CaseCreateCustomer_Controller 
{
    public Id caseId {get; set;}
    //public String returnUrl;
    
    public CaseCreateCustomer_Controller(ApexPages.StandardController stdController)
    {
        this.caseId = stdController.getId();
    }
    
    public PageReference openCreateAccount()
    {
        Case cs = [SELECT Id, AccountId, ContactId, Last_Name__c, First_Name__c, SuppliedEmail, Site_Name__c FROM Case WHERE Id = :caseId];
        
        String urlRedirect = '/lightning/o/Account/new?recordTypeId=0126g0000006zSRAAY';
        if(cs.Last_Name__c == null)
        {
            urlRedirect = urlRedirect + '&defaultFieldValues=LastName=\'\'';
        }
        else
        {
            urlRedirect = urlRedirect + '&defaultFieldValues=LastName=' + SystemUtilities.escapeHtmlCharacters(cs.Last_Name__c);
        }
        
        if(cs.First_Name__c != null)
        {
            urlRedirect = urlRedirect + ',FirstName=' + SystemUtilities.escapeHtmlCharacters(cs.First_Name__c);
        }
        
        if(cs.SuppliedEmail != null)
        {
            String emailAddress = SystemUtilities.escapeHtmlCharacters(cs.SuppliedEmail);

            System.debug(emailAddress);
            System.debug(EncodingUtil.urlEncode(emailAddress, 'UTF-8'));
            
            urlRedirect = urlRedirect + ',PersonEmail=' + EncodingUtil.urlEncode(emailAddress, 'UTF-8');
        }
        
        if(cs.Site_Name__c != null)
        {
            urlRedirect = urlRedirect + ',Channel__pc=' + cs.Site_Name__c;
        }
        
        PageReference pr = new PageReference(urlRedirect);
     
        return pr;
        
    }
    
}