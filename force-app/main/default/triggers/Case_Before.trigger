trigger Case_Before on Case (before insert, before update, before delete) 
{
    
    
    //Commenting/Inactivating this code as per the update from Business on SFSC-554 that this logic is not using any more
    //Date: 5/6/2021 by Ibad

    /* Skip this code if the User profile indicates that a data load is being performed. */
    SystemUtilities.getUserInfo(new Set<Id>{UserInfo.getUserId()});
    if(SystemUtilities.userMap.get(UserInfo.getUserId()).Data_Load_Mode__c) return;

    if(trigger.isInsert)
    {
       /* if(!SystemUtilities.isAlreadyExecuted('CaseTriggers.updateCaseContact'))
        {
            CaseTriggers.updateCaseContact(trigger.new, null, TriggerType.isInsert);
        }
        */
        if(!SystemUtilities.isAlreadyExecuted('CaseTriggers.copyWebToCaseMessage'))
        {
            CaseTriggers.copyWebToCaseMessageAndName(trigger.new);
        }
        
        //if(!SystemUtilities.isAlreadyExecuted('CaseTrigger.reassociateToOpenCase'))
        //{
        //  CaseTriggers.reassociateToOpenCase(trigger.new, TriggerType.isInsert);           
        //}
    }
    
   // if(trigger.isUpdate)
  // {
       /* if(!SystemUtilities.isAlreadyExecuted('CaseTriggers.updateCaseContact'))
        {
            CaseTriggers.updateCaseContact(trigger.new, trigger.oldMap, TriggerType.isUpdate);
        }
        */
       // if(!SystemUtilities.isAlreadyExecuted('CaseTriggers.updateAutoCloseDate'))
       // {
       //     CaseTriggers.updateAutoCloseDate(trigger.new, trigger.oldMap, TriggerType.isUpdate);
        //}
   // }
    
}