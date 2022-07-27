/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-18-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-18-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
trigger EmailMessageTrigger on EmailMessage (before insert, after insert, before update, after update, before delete, after delete, after unDelete) {
    TriggerDispatcher.run(new EmailMessageTriggerHandler(), 'EmailMessageTrigger');
}