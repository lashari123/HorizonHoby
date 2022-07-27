({
    checkOwnerChange : function(component, helper) {
        //alert('checkOwnerChange function');
        
        var action = component.get("c.getCaseOwner");
        if(action != undefined)
        {
            action.setParams({ recordId : component.get("v.recordId") });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") 
                {
                    var caseOwnerId = "";
                    var caseOwnerName = "";
                    
                    var strResponse = response.getReturnValue().split("_");
                    
                    caseOwnerId = strResponse[0];
                    caseOwnerName = strResponse[1];
                    
                    //if(component.get("v.currentUser") == caseOwnerName)
                    //{
                    //    //alert('checkOwnerChange first if');
                    //    component.set("v.caseOwner", "You are the current Case Owner");
                    //    component.set("v.updateowner", false);
                    //}
                    //else
                    //{
                       	//alert('checkOwnerChange else');
                        // Get the current User and the Case Owner
                        // If the Case Owner Id is a User, then confirm if it is a different user or the Current User
                        // If it is a different user, change the div tag color to orange
                        // If it is the current user, keep the div tag color blue
                        // If it is a Queue Id, then kick off the helper.changeOwner function
                        
                    if(caseOwnerId.startsWith('00G'))
                    {
                        helper.changeOwner(component, helper);
                    }
                    else if(caseOwnerId != $A.get("$SObjectType.CurrentUser.Id"))
                    {
                        var csOwner = component.find("caseowner");
                        $A.util.removeClass(csOwner, "currentOwner");
                        $A.util.addClass(csOwner, "otherOwnerAssigned");
                        
                        var strMessage = caseOwnerName + ' is the current owner';
                        component.set("v.caseOwner", strMessage);
                    }
                    else if(caseOwnerId == $A.get("$SObjectType.CurrentUser.Id"))
                    {
                    	component.set("v.caseOwner", "You are the current Case Owner");
                        component.set("v.updateowner", false);
                    }
                }
            });
    
            $A.enqueueAction(action);
        }
    },
    
    changeOwner : function(component, helper) {
        //alert('changeOwner function');
        var action = component.get("c.changeCaseOwner");
        if(action != undefined && component.get("v.updateowner") == true)
        {
            action.setParams({ recordId : component.get("v.recordId") });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") 
                {
                    var caseOwnerId = "";
                    var caseOwnerName = "";
                    
                    var strResponse = response.getReturnValue().split("_");
                    
                    caseOwnerId = strResponse[0];
                    caseOwnerName = strResponse[1];
                    
                    if(component.get("v.currentUser") == caseOwnerName)
                    {
                        //alert('changeOwner if');
                        component.set("v.caseOwner", "You are the current Case Owner");
                        component.set("v.updateowner", false);
                    }
                    else
                    {
                        //alert('changeOwner else');
                        var strMessage = caseOwnerName + ' is the current owner';
                        component.set("v.caseOwner", strMessage);
                        component.set("v.updateowner", false);
                    }
                    
					$A.get('e.force:refreshView').fire();
                }
            });
    
            $A.enqueueAction(action);
        }
    }
    
})