({
    
    doInit : function(component, event, helper) {
               
        var locale = $A.get("$Locale.language");
        if(locale == 'en'){
            component.set("v.languageSelectedValue", 'Eng');
            component.set("v.languageSelectedValueLowerCase", 'eng');
        } else if(locale == 'de'){
            component.set("v.languageSelectedValue", 'Ger');
            component.set("v.languageSelectedValueLowerCase", 'ger');
        } else if(locale == 'fr') {
            component.set("v.languageSelectedValue", 'Fre');
            component.set("v.languageSelectedValueLowerCase", 'fre');
        }
             
      /*  var action = component.get('c.getCurrentLanguage');
            
       	action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if (resp != null && resp.length >= 0) {
                    
                    component.set("v.languageSelectedValue", resp);
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
        $A.enqueueAction(action);*/
    },
    
	languageSelected : function(component, event, helper) {
        
        var Language = event.currentTarget.id;
        //var pascalCaseLangu
        component.set("v.languageSelectedValue",Language);
        var action = component.get("c.changeLanguage");
      //  helper.changeFlagHelper(component, event, helper);
        action.setParams({ Language : Language});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('SUCCESS');
                component.set("v.showAlert", true);
                //location.reload();
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
        
    },
    languageFlagSelected : function(component, event, helper) {
      helper.changeFlagHelper(component, event, helper);
    }
})