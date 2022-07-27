({
    doInit : function(component, event, helper) {
        var action = component.get("c.getContactNumber")
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set('v.conId',response.getReturnValue().Contact.Id)
                component.set('v.contactNumber',response.getReturnValue().Contact.MobilePhone);
                component.set('v.selectedValue','Order question')
                component.set('v.message','');
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
                else{
                    console.log('Failed with state: ' + state);
                }
        });
        
        $A.enqueueAction(action);
        var message = 'Test';
       var vfOrigin = "https://b2bdev-horizonhobbysupport.cs166.force.com";
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        vfWindow.postMessage(message, vfOrigin);
    },
    openModal : function(component, event, helper) {
        component.set("v.isOpen",true)
    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
       
        $A.enqueueAction(component.get("c.doInit")); 
        component.set("v.isOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        debugger
           var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if( allValid){
            var action = component.get("c.createTask")
            action.setParams({
                'contactId': component.get('v.conId') ,
                'ContactNumber':component.get('v.contactNumber'),
                'Message':component.get('v.message'),
                'subject':component.get('v.selectedValue')
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    component.find('notifyId').showToast({
                        "variant": "Success",
                        "title": "Success!",
                        "message":  "Thank you, your callback request has been received. We will contact you shortly."
                    });
                    
                   
                    
                    $A.enqueueAction(component.get("c.doInit")); 
                    
                    component.set("v.isOpen", false);
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
                    else{
                        console.log('Failed with state: ' + state);
                    }
                
              
            });
            
            $A.enqueueAction(action); 
        }
        else{
            component.find('notifyId').showToast({
                "variant": "Error",
                "title": "Error!",
                "message":  "Please Fill all the field."
            });
        }
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        
    },
})