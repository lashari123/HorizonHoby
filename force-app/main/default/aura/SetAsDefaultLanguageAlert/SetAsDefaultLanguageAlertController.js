({
    doInit : function(component, event, helper){
        component.set("v.show", true);
        var Language = component.get("v.languageSelectedValue");
       	if(Language != 'Eng' && Language != 'eng'){
            var action = component.get("c.getTranslations");
            action.setParams({ langCode : Language});
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data =  response.getReturnValue();
                    //var message = component.get('v.message');
                    var Yes = component.get('v.Yes');
                    var No = component.get('v.No');
                    var message = 'LanguageAlert'
                    
                    message= data[message];
                    Yes= data[Yes];
                    No= data[No];
                    
                	component.set('v.message',message);
                    component.set('v.Yes',Yes);
                    component.set('v.No',No);
                    
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // log the error passed in to AuraHandledException
                            console.log("Error message: " + 
                                     errors[0].message);
                        }
                    }
                }
            });
        	$A.enqueueAction(action);
        } 
    },
    
    Yes : function(component, event, helper){
        var Language = component.get("v.languageSelectedValue");
        console.log(Language);
        var action = component.get("c.changeDefaultLanguage");
        action.setParams({ Language : Language});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('SUCCESS');
                location.reload();
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
    
    No : function(component, event, helper){
        location.reload();
    },
    
    closeModal2 : function(component, event, helper){
        event.stopPropagation();
    },
    
    closeModal : function(component, event, helper){
       	var f = component.get('c.cancelAction');
        $A.enqueueAction(f);
    },
    
    cancelAction : function(component, event, helper) {
        var action = component.get("c.setDefaultLanguage");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('SUCCESS (Cancel action on Language Alert)');
                component.set("v.show", false);
                location.reload();
               // $A.get("e.force:closeQuickAction").fire();
                //$A.get('e.force:refreshView').fire();
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
      /*  component.set("v.show", false);
        var cmpTarget = cmp.find('MainDiv');
        $A.util.removeClass(cmpTarget, 'slds-modal');
         $A.get('e.force:refreshView').fire();*/
        
    }
})