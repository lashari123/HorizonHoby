({
	doInit : function(component, event, helper) {
         
        var locale = $A.get("$Locale.language");
        var lang = 'English'
        if(locale == 'de'){
            lang = 'German';
        } else if(locale == 'fr') {
           	lang = 'French';
        }
        var action = component.get('c.getImprint');
        action.setParams({ Lang : lang});
        action.setCallback(this, function(response){ 
            var state = response.getState(); 
            if(state === "SUCCESS") { 
                var resp = response.getReturnValue(); 
                console.log('SUCCESS: getImprint'); 
                if (resp != null) { 
                   // component.set("v.imprintObject", resp); 
                    component.set("v.test", resp);
                } 
            } else if (state === "ERROR") { 
                var errors = response.getError(); 
                if (errors) { 
                    if (errors[0] && errors[0].message) { 
                        console.log("Error message: " +  
                                 errors[0].message); 
                    } 
                } 
            } 
            else{ 
                console.log(response.getReturnValue()); 
                console.log('Failed with state: ' + state); 
            } 
        });  
        //send action to be executed 
        $A.enqueueAction(action); 
        
	}
})