({
    init : function(component, event, helper) {
        var deleteAll = component.get('v.deleteAll');
        var callName = component.get('v.callName');
        var msg = '';
        if(callName == 'Delete'){
            component.set('v.title', 'Delete Items');
            if(deleteAll){
                msg = 'removing all order lines will cause this draft order to be deleted. proceed?';
            } else {
                msg = 'Do you want to delete the selected order line items?';
            }
        } else{
            component.set('v.title', 'Move Items');
            msg = 'Moving all order line items will cause this draft order to be deleted, do you want to proceed?';
            component.set('v.Yes', 'YES MOVE, DELETE');
        }
        component.set('v.message', msg);
    },
	Yes : function(component, event, helper){
		var callName = component.get('v.callName');
        if(callName == 'Delete'){
            var action = component.get('c.deleteOrderLineItems');
            var orderId = component.get('v.orderId');
            var deleteAll = component.get('v.deleteAll');
            
            var selectedValues = component.get('v.SelectedValues');
            action.setParams({ orderID : orderId,
                              products : selectedValues,
                              deleteAll: deleteAll});
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    console.log('Success: deleteOrderLineItems');
                    if(resp!=null && resp.includes("Error")){
                        console.log(resp);
                    } else{
                        if(deleteAll){
                            component.set('v.deleteAll', false);
                            location.assign("/horizonhobby/s/order-summary");
                        } else{
                            location.reload();
                        }
                    }
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // log the error passed in to AuraHandledException
                            console.log("Error message: " + 
                                     errors[0].message);
                        }
                    }
                }
                else{
                    console.log('Failed with state: ' + state);
                }
            });
            
            //send action to be executed
            $A.enqueueAction(action);
        } else if(callName == 'NewOrder'){
            debugger;
            var compEvent = component.getEvent("MoveOrderLineItemEvent"); 
            var isNew = true;
            compEvent.setParams({ "isNew" : isNew}); 
            compEvent.fire();
            component.set("v.show", false);
        } else if(callName == 'ExistingOrder'){
            var compEvent = component.getEvent("MoveOrderLineItemEvent"); 
            var isNew = false;
            compEvent.setParams({ "isNew" : isNew}); 
            compEvent.fire();
            component.set("v.show", false);
        }
    },
    
    No : function(component, event, helper){
        component.set("v.show", false);
    },
    
    closeModal2 : function(component, event, helper){
        event.stopPropagation();
    },
    
    cancel : function(component, event, helper){
    	component.set("v.show", false);
	}
})