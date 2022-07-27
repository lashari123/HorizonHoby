trigger HHfilterTrigger on HH_Filter__c (before delete, before update) {
    
    for (HH_Filter__c hf : Trigger.old) {
        
        if(trigger.isDelete){
            if(hf.isDeletable__c== false)
                hf.addError('You can not delete this record. Contact your administrator.');
        }
    }
    
    for (HH_Filter__c hf : Trigger.new) {
        if(trigger.isUpdate){
            if(hf.isEditable__c== false)
                hf.addError('You can not edit this record. Contact your administrator.');
        }
    }
}