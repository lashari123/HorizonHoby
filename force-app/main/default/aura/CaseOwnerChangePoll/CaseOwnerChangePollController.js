({
    doInit : function(component, event, helper) 
    {
		//alert('doInit function');
        
        var action = component.get("c.getCurrentUser");
        //action.setParams({ userId : $A.get("$SObjectType.CurrentUser.Id") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set("v.currentUser", response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
        
        if(component.get("v.updateowner") == true)
        {
            //alert('call to helper function');
	        helper.checkOwnerChange(component, helper);
        }
    }
})