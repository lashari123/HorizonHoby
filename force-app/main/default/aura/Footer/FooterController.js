({
    init : function(component, event, helper) {
        var action = component.get("c.getManagerDetails")
        action.setParams({uId:  $A.get("$SObjectType.CurrentUser.Id")})
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log(response.getReturnValue())
                //alert("");
                component.set("v.manager",response.getReturnValue())
            }
              
        });
        
        $A.enqueueAction(action);
	}
})