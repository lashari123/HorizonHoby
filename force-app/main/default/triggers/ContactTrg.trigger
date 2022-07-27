/************************
Author:         Ibad Mohiuddin
Created Date:   06/01/2020 
Purpose:        This Trigger will be used for converting the contact into the Person Accounts.

************************MODIFICATION HISTORY**************************************
Added on             Added By               Description
**********************************************************************************
***********************************************************************************/


trigger ContactTrg on Contact (before insert,after insert) {
    // Return if trigger is inactive from custom meta data type
    TriggerSetting__c objTrgActive = [Select isDisabled__c from TriggerSetting__c where Name = 'ContactTrg'];
    
    if(objTrgActive.isDisabled__c )
        return ;
    
    private static RecordType PersonAccount = [SELECT id FROM RecordType WHERE  sObjectType = 'Account' and ispersontype = true and isActive = true limit 1];
    if (Trigger.isBefore && Trigger.isInsert){
        try{
            Map<Contact,Account> mapContactIdtoAccount = New Map<Contact,Account>();
            if(UserInfo.getName()=='Automated Process'){
                for (Contact newContact : Trigger.new){
                    Account accountObj = new Account(Name = 'HorizonHobbyAccount');
                    accountObj.By_Pass_Validation__c=true;
                    mapContactIdtoAccount.put(newContact,accountObj);
                }
                
                if(mapContactIdtoAccount.size()>0){
                    insert mapContactIdtoAccount.values();
                }
                
                
                if(mapContactIdtoAccount.size()>0){
                    for(Contact contactObj:mapContactIdtoAccount.keySet()){
                        contactObj.accountid=mapContactIdtoAccount.get(contactObj).id;
                        
                    }
                }
            }
        } catch (Exception ex) {
            ExceptionLogger.LogException(ex);
        }
    }
    
    if (Trigger.isAfter && Trigger.isInsert){
        try{
            if(UserInfo.getName()=='Automated Process'){
                List<Account> accList = new List<Account>();
                Set<sObject> ObjectsToUpdate = new Set<sObject>();
                Map<Id, Account> AccountsMap = new Map<Id, Account>([SELECT id FROM Account WHERE id IN (SELECT AccountId FROM Contact WHERE Id IN :trigger.newMap.keySet())]);
                for (id aId : AccountsMap.keySet()){
                    Account a = AccountsMap.get(aId);
                    a.RecordTypeId = PersonAccount.id;
                    accList.add(a);
                    
                }
                
                if(accList.size()>0){
                    update accList;
                }
            }
        } catch (Exception ex) {
            ExceptionLogger.LogException(ex);
        }
    }
}