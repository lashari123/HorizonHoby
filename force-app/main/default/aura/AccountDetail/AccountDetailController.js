({
    init : function(component, event, helper) {
        var action = component.get("c.getAccountDetail");
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state == 'SUCCESS'){
                debugger 
                var adw = response.getReturnValue();
                component.set('v.Data',JSON.parse(adw));
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action); 
        
    }
})