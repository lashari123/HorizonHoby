public class CloseCase_Controller 
{
    public List<Case> caseList;
    String returnUrl;
    
    public Boolean listView = false;
    
    public CloseCase_Controller(ApexPages.StandardSetController ssc)
    {
        returnUrl = ApexPages.currentPage().getParameters().get('vfRetURLInSFX');

        caseList = new List<Case>();
        caseList = (List<Case>)ssc.getSelected();
        this.listView = true;
    }
    
    
    public PageReference setCaseStatusToClosed()
    {
        if(caseList.size() > 0)
        {
            List<Case> casesToClose = new List<Case>([SELECT Id, Status FROM Case WHERE Id IN :caseList]);
            for(Case c : casesToClose)
            {
                c.Status = 'Closed';
                c.Sub_Status__c = '';
            }
            
            database.update(casesToClose, false);
        }
        
        if(listView = true && returnUrl != null && returnUrl != '')
        {
            PageReference pr = new PageReference(returnUrl);
            pr.setRedirect(true);
            return pr;            
        }
        else
        {
            return null;
        }
    }

}