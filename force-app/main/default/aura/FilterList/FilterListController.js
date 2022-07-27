({
    doInit : function(component, event, helper) {
        var name = component.get("v.name");
        if(name != undefined && name != null && name != ''){
            component.find('Name').set("v.value", name);
            component.set("v.heading", 'Edit List');
            component.set("v.buttonLabel", 'Edit');
        }
        
        
    },
    
	SaveList:function (component, event, helper) {
        var name = component.find('Name').get("v.value")
        var renderedList = component.get("v.renderedList");
        var buttonLabel = component.get("v.buttonLabel");
        var editListId = component.get("v.editListId");
        
        if(buttonLabel == 'Save'){
            var action = component.get('c.CreateFilterList');
            action.setParams({ attributeList : JSON.stringify(renderedList),
                              Name : name});
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp == 'Success'){
                        console.log('SUCCESS: CreateFilterList');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "Filter List Saved"
                        });
                        toastEvent.fire();
                        location.reload();

                    }
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
            
            //send action to be executed
            $A.enqueueAction(action);
        } else {
            var action = component.get('c.UpdateFilterList');
            action.setParams({ attributeList : JSON.stringify(renderedList),
                              Name : name,
                              Id : editListId});
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp == 'Success'){
                        console.log('SUCCESS: UpdateFilterList');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "Filter List Updated"
                        });
                        toastEvent.fire();
                        debugger;
                        //Event fired to update Saved Filter List dropdown
                        var compEvent = component.getEvent("SavedFilterListUpdatedEvent");                        
                        compEvent.fire();
                        
                        //Closing Component
                        component.set("v.show", false);
                    }
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
            
            //send action to be executed
            $A.enqueueAction(action);
        }
        
        
    },
    cancelAction : function(component, event, helper) {
        component.set("v.show", false);
        
    },
    
    Remove:function (component, event, helper) {
        var currentTarget = event.currentTarget;
        var renderedListId = currentTarget.getAttribute("data-renderedListId");
        
        var field = renderedListId.split('_')[0];
        var fieldIterator = parseInt(renderedListId.split('_')[1]);
        var ListIterator = parseInt(renderedListId.split('_')[3]);
        
        //Removing from Rendered List
        var renderedList = component.get("v.renderedList");
    	renderedList.splice(ListIterator, 1);
        component.set("v.renderedList", renderedList);
        
    },
    
    closeModal : function(component, event, helper){
        event.stopPropagation();
    }
})