public class CaseAutoClose_Schedulable implements Schedulable
{
    public Set<Id> testIds;
    
	public void execute(SchedulableContext ctx)
    {
        CaseAutoClose_Batchable caseAutoClose = new CaseAutoClose_Batchable();
        
        if(Test.isRunningTest())
        {
            caseAutoClose.caseTestIds = this.testIds;
        }

        database.executeBatch(caseAutoClose, 100);
    }
}