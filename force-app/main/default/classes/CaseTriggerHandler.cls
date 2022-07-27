public class CaseTriggerHandler implements ITriggerHandler {
    
 
     
    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
     
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
     
    public void beforeInsert(List<sObject> newList) {
        
       CaseTriggerHelper.SettingDefaultValues(newList);

    }
     
    public void afterInsert(List<sObject> newList , Map<Id, sObject> newMap) {
         if(Trigger.isInsert && Trigger.isAfter)
            {
            
            }
    }
     
    public void beforeUpdate(List<sObject> newList, Map<Id, sObject> newMap, List<sObject> oldList, Map<Id, sObject> oldMap) {
        CaseTriggerHelper.AssociateCaseContact(newList);
         CaseTriggerHelper.SettingDefaultValues(newList);
    }
     
    public void afterUpdate(List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap) {
       
    }
     
  /*  public void beforeDelete(List<sObject> oldList , Map<Id, sObject> oldMap) {
         
    }
     
    public void afterDelete(List<sObject> oldList , Map<Id, sObject> oldMap) {
         
    }
     
    public void afterUnDelete(List<sObject> newList, Map<Id, sObject> newMap) {
         
    } */
}