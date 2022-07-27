trigger Account_After on Account (after insert, after update, after delete) 
{
    
    /* Skip this code if the User profile indicates that a data load is being performed. */
   /* SystemUtilities.getUserInfo(new Set<Id>{UserInfo.getUserId()});
    if(SystemUtilities.userMap.get(UserInfo.getUserId()).Data_Load_Mode__c) return;

    if(trigger.isInsert)
    {
        if(!SystemUtilities.userMap.get(UserInfo.getUserId()).Data_Load_Mode__c)
        {
            CaseTriggers.updateCaseContact(trigger.new);
        }
    } */
}