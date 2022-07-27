({
    doInit : function(component, event, helper) {
        var action = component.get("c.getManufacturersList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var manufacturerList = response.getReturnValue();
                if(manufacturerList.length > 0){
                    component.set("v.brandList",manufacturerList);
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
            } else{
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action);
       // alert('Test');
    },
    
    BrandSelected : function(component, event, helper){
        var manId = component.find("Brand").get("v.value");
        var action = component.get("c.getProductList");
        action.setParams({ manId : manId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var prodList = response.getReturnValue();
                if(prodList.length > 0){
                    component.set("v.prodList",prodList);
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
            } else{
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action); 
    },
    
	closeModal2 : function(component, event, helper){
        event.stopPropagation();
    },
    
    cancelAction : function(component, event, helper){
    	component.set("v.show", false);
	}
})