({
	doInit : function(component, event, helper) {
        var action = component.get('c.sendingEmail');
        
        action.setCallback(this, function(response){
          var state = response.getState();
            debugger;
            console.log('state: '+ state);
            //alert(state);
            if(state == 'SUCCESS'){
               
                component.set('v.syncText',response.getReturnValue());
                
            }

        });
        $A.enqueueAction(action);
    }
})