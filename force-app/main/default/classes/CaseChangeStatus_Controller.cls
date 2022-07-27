public class CaseChangeStatus_Controller 
{
    private List<Case> caseList;
    private Map<String, String> urlHeaders;
    private Map<String, String> urlParams;
    
    public CaseChangeStatus_Controller(ApexPages.StandardSetController ssd)
    {
        PageReference currentPage = ApexPages.currentPage();
        urlHeaders = currentPage.getHeaders();
        urlParams = currentPage.getParameters();
        this.caseList = new List<Case>();
        this.caseList = ssd.getSelected();
    }
    
    public PageReference changeStatusToOpen()
    {
        if(!caseList.isEmpty())
        {
            List<Case> casesToReview = [SELECT Id, Status FROM Case WHERE Id IN :caseList];
            List<Case> casesToUpdate = new List<Case>();
            for(Case cs : casesToReview)
            {
                if(cs.Status == 'New')
                {
                	cs.Status = 'Open';
                    casesToUpdate.add(cs);
                }
            }
            
            if(!casesToUpdate.isEmpty())
            {
            	database.update(casesToUpdate, false);                
            }
        }
        
        if(Test.isRunningTest())
        {
            return null;
        }
        else
        {
            PageReference pr = new PageReference(urlParams.get('vfRetURLInSFX'));
            pr.setRedirect(true);
            return pr;            
        }
    }
    
}