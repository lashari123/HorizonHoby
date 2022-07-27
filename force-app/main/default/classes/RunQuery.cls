global class RunQuery implements Database.Batchable<AggregateResult> { 
    
    global Iterable<AggregateResult> start(Database.BatchableContext BC){ 
          String query = 'Select Count(id)cnt,Department__c,Owner.Name,Status,Owner.UserRole.Name u from Case where createddate=Today and (Status != \'Closed\' AND Status != \'Merged\')    Group BY  Department__c, Owner.Name,Status,Owner.UserRole.Name';
    //return Database.getQuerylocator(query);
     return new AggregateResultIterable(query);   
     //   return new AggregateResultIterable(); 
    } 
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){ 
        list<Cases_Snapshot__c> Cslist=new list<Cases_Snapshot__c>();
       
        for(sObject sobj : scope){ 
         Cases_Snapshot__c Cs=new Cases_Snapshot__c();
             AggregateResult ar = (AggregateResult)sObj;
            System.debug('----------' + ar.get('Department__c')); 
          //  for(Cases_Snapshot__c CSL:Cs){
                
            Cs.Department__c=String.valueOf(ar.get('Department__c'));
          	Cs.Owner_Name__c=String.valueOf(ar.get('Name'));
            Cs.Count__c=Double.valueOf(ar.get('cnt'));
            Cs.Date__c=Date.today();
            CS.Status__c=String.valueOf(ar.get('Status'));
            Cs.Owner_Role__c=String.valueOf(ar.get('u'));
            
            Cslist.add(Cs);
            System.debug('1----------' + Cslist); 
           // }
        } 
        Insert Cslist;
    } 
    
    global void finish(Database.BatchableContext BC){ 
       /* AsyncApexJob a = 
            [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems,CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()]; 
        System.debug('********: ' + a.Id); */
    } 
}