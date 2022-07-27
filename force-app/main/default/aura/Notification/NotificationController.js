({
	 doInit : function(component, event, helper) {
        //Getting Notification
        var action = component.get("c.getNotification");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS'){
                var notificationMessage = response.getReturnValue();
                if(notificationMessage!= null && notificationMessage!=''){
                    component.set("v.notificationMessage",notificationMessage);
                }
                console.log("Get Notification method SUCCESS")
            } else if (state === "ERROR") {
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