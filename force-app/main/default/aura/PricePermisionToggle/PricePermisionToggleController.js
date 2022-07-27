({
    doInit :function(component,event,helper){
          component.set('v.loaded', false);
      //  var checkCmp = component.find("tglbtn").get("v.checked");
        
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = action = component.get('c.isPermissionAssigned');
        
        action.setParams({myAssigneeId: userId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.chkboxvalue",resp);
            }
            
           
        }); 
        $A.enqueueAction(action);
    },
    getToggleButtonValue:function(component,event,helper){
        var checkCmp = event.currentTarget.checked//component.find("tglbtn").get("v.checked");
        
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = ''
        if(!checkCmp){
            action =component.get('c.givePermission');
        }
        else{
           action = component.get('c.deletePermission');
        }
         component.set('v.loaded', true);
        action.setParams({myAssigneeId: userId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.chkboxvalue",checkCmp);
                location.reload();
                

            }
            
           
        }); 
        $A.enqueueAction(action);
    },
})