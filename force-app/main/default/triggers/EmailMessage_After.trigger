trigger EmailMessage_After on EmailMessage (after insert, after update, after delete, after undelete) 
{
    /* Skip this code if the User profile indicates that a data load is being performed. 
    SystemUtilities.getUserInfo(new Set<Id>{UserInfo.getUserId()});
    if(SystemUtilities.userMap.get(UserInfo.getUserId()).Data_Load_Mode__c) return;

    if(trigger.isInsert)
    {
        if(!SystemUtilities.isAlreadyExecuted('EmailMessage.reopenClosedCases'))
        {
            EmailMessageTriggers.reopenClosedCases(trigger.new, TriggerType.isInsert);
        }
    } */
}