@istest
public class RunQueryTest {


static testmethod void test() {

            SystemUtilities.getQueues();
        insert new TriggerSetting__c(Name = 'CaseTrigger',isDisabled__c=false);
        insert new TriggerSetting__c(Name = 'AccountTrigger',isDisabled__c=false);
        List<Account> persAcctTest = TestFactory.createPersonAccount(1);
        persAcctTest[0].Channel__pc = 'horizon-us';
        insert persAcctTest;
    User psUser = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'US Product Support' LIMIT 1];
        System.debug('checking'+psUser);
        List<Case> testCaseList = TestFactory.createTestEmailToCase(5, '@horizonhobby.com');
		for(Group grp : SystemUtilities.queueMap.values())
        {
            if(grp.Name == 'HH Customer Support')
            {
        		//testCaseList[0].OwnerId = grp.Id;
                testCaseList[0].Form_Message__c = 'Test Web to Case Message';
                 testCaseList[0].Status='Open';
                testCaseList[0].OwnerId=psUser.Id;
                    
                   
         //   testCaseList[0].Department__c='Product Support';
          
           
                
            }
        }

        insert testCaseList;
     system.debug('caseline'+testCaseList[0].OwnerId);
        Test.startTest();
 
 
RunQuery c = new RunQuery();
    ID batchprocessid = Database.executeBatch(c);
//Database.executeBatch(c,200);
ScheduledCaseSnapshot SCS=new ScheduledCaseSnapshot();
DateTime sysTime = System.now();
sysTime = sysTime.addMinutes(2);
String chronJobId = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();

//schedule a job
System.schedule('Batch Contact Update Auto'+chronJobId, chronJobId, SCS);
Test.stopTest();
    
 // Cases_Snapshot__c Cs = [select status__c from Cases_Snapshot__c ];
  //    system.debug('casesnapshot'+Cs);
}
}