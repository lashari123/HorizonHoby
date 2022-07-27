public class CaseAutoClose_Batchable implements Database.Batchable<sObject>
{
	public Set<Id> caseTestIds;
    public String query;
    
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        if(Test.isRunningTest())
        {
            query = 'SELECT Id, Status, Sub_Status__c, Auto_Close_Date__c, Auto_Closed__c ' +
                    'FROM Case ' +
                    'WHERE Id IN :caseTestIds ' +
                    'AND IsClosed = False ' +
                    'AND Sub_Status__c = \'Open: Need Customer reply\'';
        }
        else
        {
            query = 'SELECT Id, Status, Sub_Status__c, Auto_Closed__c, Auto_Close_Date__c ' + 
                    'FROM Case ' + 
                    'WHERE IsClosed = False ' + 
                    'AND Sub_Status__c = \'Open: Need Customer reply\'' + 
                    'AND Auto_Close_Date__c <= TODAY';
        }
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<sObject> scope)
    {
        for(sObject s : scope)
        {
            Case cs = (Case)s;
            cs.Status = 'Closed';
            cs.Sub_Status__c = '';
            cs.Auto_Closed__c = true;
        }
        
        database.update(scope);
    }
    
    public void finish(Database.BatchableContext bc){}
}