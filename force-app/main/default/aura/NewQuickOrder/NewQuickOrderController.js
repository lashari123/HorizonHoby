({
    doInit : function(component, event, helper) {
        var value = '1';
        var iterationValues = component.get("v.iterationValues");
        iterationValues[0] = value;
        component.set("v.iterationValues",iterationValues);
    },
    
    Add:function (component, event, helper) {
        
        
        var sku = component.find("sku");
        var quantity = component.find("quantity");
        var skuQuantityList = component.get("v.skuQuantityList");
        var Products = component.get("v.Products");
        debugger;
        var j = 0;
        for (var i=0; i<sku.length; i++) {
            Products[sku[i].get('v.value')] = quantity[i].getElements()[0].value;
            if(sku[i].get('v.value') != ''){
                if(quantity[i].getElements()[0].value == 0){
                    skuQuantityList[j] = sku[i].get('v.value') + '_' + 1;
                    sku[i].set('v.value','');
                } else{
                skuQuantityList[j] = sku[i].get('v.value') + '_' + quantity[i].getElements()[0].value;
                    sku[i].set('v.value','');
                    quantity[i].getElements()[0].value = 0;
                }
                j++;
                console.log(skuQuantityList[i]);
            }
            //console.log(quantity[i].get('v.value'));
        }
        
        if(skuQuantityList.length > 0){    
            component.set("v.iterationValues",{});
            component.set("v.showAddToDraftOrder",true);
            component.set("v.show",false);
        } else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "Enter Product Code and Quantity to Add to Draft Orders"
            });
            toastEvent.fire();
        }
    },
    
    newInputs:function (component, event, helper) {
        /*var sku = component.find("sku");
        var allowAddRows = true
        for (var i=0; i<sku.length; i++) {
            if(sku[i].get('v.value') == ''){
                allowAddRows = false;
                break;
            }
        }
        if(allowAddRows) {*/
            var value = '1';
            var iterationValues = component.get("v.iterationValues");
            iterationValues.push(value);            
            component.set("v.iterationValues",iterationValues);
      /*  } else {
            	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": "Add Product Code in all the current provided input"
                });
                toastEvent.fire();
        }*/
    },
    
    checkValidity:function (component, event, helper) {
        debugger;
        var sku = event.getSource().get('v.name');
        var skuValue = '';
        var skuinstance = null
        var skuList = component.find("sku");
        skuList.forEach( skuElement=> {
            if(skuElement.get('v.name') == sku){
            skuValue= skuElement.get('v.value'); 
            skuinstance = skuElement;
        }});
        var action = component.get('c.CheckSKUValidity');
        action.setParams({ sku : skuValue});
            
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp){
                    console.log("SUCCESS: Valid Product Code");
                } else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Entered Wrong Product Code"
                    });
                    toastEvent.fire();
                    skuinstance.set('v.value', '');
                    component.set("v.showAddToDraftOrder",false);
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
        
        //send action to be executed
        $A.enqueueAction(action);
    },
       onChange : function(component,event,helper){ 
        debugger
        
        var intVal= parseInt(event.currentTarget.value);
        
        if(isNaN(intVal)){
            intVal=''
        }
        
        if(intVal<0)
        {
            intVal*=-1
            event.currentTarget.value = intVal;
        }
       
        
        
      
    }, 
  
    increment:function (component, event, helper) {
        debugger;
        var buttonName = event.getSource().get('v.name');
        var row = buttonName[1];
        var column = buttonName[0];
        
        var quantity = component.find("quantity");
        quantity.forEach( qty=> {
            if(qty.getElements()[0].name == buttonName){
            var intVal= parseInt(qty.getElements()[0].value)
            if(intVal <0)
            {
            	intVal=0
      		}
            if(isNaN(intVal)){
            	intVal=0
       		}
            qty.getElements()[0].value = intVal + 1;
            
        }
                         });
        
        
    },
    decrement:function (component, event, helper) {
        var buttonName = event.getSource().get('v.name');
        var row = buttonName[1];
        var column = buttonName[0];
        
        var quantity = component.find("quantity");
        quantity.forEach( qty=> {
            if(qty.getElements()[0].name == buttonName){
            var intVal= parseInt(qty.getElements()[0].value)
            if(isNaN(intVal)){
            	intVal=0
        	}
        
            if(intVal-1 <0)
            {
                intVal=1
            }
        	qty.getElements()[0].value = intVal - 1;
            
        }
                         });
        
    },
        
})