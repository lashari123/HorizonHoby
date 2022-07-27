trigger OrderTrigger on Order (after insert, after update) {
    
    orderTriggerHandler handler = new orderTriggerHandler();
    
    if(trigger.isafter == true && trigger.isInsert == true){
        
        handler.sendDataToMs(trigger.new);
    }
    
    else if(trigger.isafter == true && trigger.isupdate == true){
        
        handler.sendDataToMs(trigger.new);
    }
}