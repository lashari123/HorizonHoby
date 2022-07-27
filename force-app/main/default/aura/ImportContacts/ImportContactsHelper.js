({
    getCSVContent:function (component, event, helper) {
        debugger;
        var dealerContId = component.get('v.dealerContactId');
        var action = component.get('c.getCSVContent');
        action.setParams({ recordId : dealerContId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                debugger;
                var resp = response.getReturnValue();
                //alert(resp);
                //alert(resp);
                /**
                var OrderLines = [];
                //var conts = response.getReturnValue();
                for(var key in resp){
                    OrderLines.push({value:resp[key], key:key});
                }
                **/
                component.set("v.skuQuantityList", resp);
                
                //draft orders
                //component.set('v.showAddToDraftOrder',true);
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
    getCSVContentB:function (component, event, helper) {
        debugger;
        var dealerContId = component.get('v.dealerContactId');
        var action = component.get('c.getCSVContent');
        action.setParams({ recordId : dealerContId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                debugger;
                var resp = response.getReturnValue();
                component.set("v.skuQuantityList", resp);
                
                //draft orders
                //component.set("v.showDraftOrders",true);
                //component.set('v.showAddToDraftOrder',true);
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
    addProductsToNewOrder:function (component, event, helper) {
        
        var action = component.get('c.addToNewOrder');
     
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                debugger;
                if (resp != null) {
                    var orderList = component.get("v.orderList");
                    //orderList.push(resp);
                    //component.set("v.orderList", orderList);
                    console.log(resp);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "New Order Created!"
                    });
                    toastEvent.fire();
                    
                    // Event fired when it is called from cart page (Move to New Order)
                    // Event fired so that all the line items that are moved are deleted from respective draft order
                    /**
                    if(component.get("v.onlyNewOrder")){
                        var compEvent = component.getEvent("DeleteOrderLineItemEvent");                        
                        compEvent.fire();
                    }
                    **/
                    component.set("v.loaded", true);
                    window.setTimeout(
                        $A.getCallback(function() {
                            component.set("v.loaded", false);
                            var a = component.get('c.getListOfOrders');
                            debugger;
                            component.set("v.showNewOrder",true);
                            $A.enqueueAction(a);
                            debugger;
                        }), 2000
                    );
                    
                    
                    //event.getSource().set("v.label","Created")
                    component.set("v.isCreated", true);
                   // component.set("v.showNewOrder",true);
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
    },
    Add:function (component, event, helper, orderId) {
        debugger;
        
        //var currentTarget = event.currentTarget;
        //var orderId = currentTarget.getAttribute("data-orderId");
        //var text = currentTarget.text;
        if(orderId!=null){
            var skuQuantityList = component.get("v.skuQuantityList");
            var skuQuantityListString=JSON.stringify(skuQuantityList);
            
            var action = component.get('c.addOrderItem');
            action.setParams({ skuQuantityListString : skuQuantityListString,
                              orderId : orderId});
            
            action.setCallback(this, function(response){
                debugger;
                var state = response.getState();
                console.log('state::'+state);
                if(state === "SUCCESS") {
                    debugger;
                    console.log('SUCCESS: Products Added to the Selected Order');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Products Added to the Selected Order"
                    });
                    toastEvent.fire();
                    
                    
                    component.set('v.showDraftOrders',false);
                    //close import modal and take the dealer to checkout:
                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/cart/?oid="+orderId
                    });
                    urlEvent.fire();
                     
                    //'../s/cart/?oid='+ order.Id
                    /**
                    // Event fired when it is called from cart page (Move to Existing Order)
                    // Event fired so that all the line items that are moved are deleted from respective draft order
                    if(component.get("v.onlyDraftOrder")){
                        component.set('v.singleDraftOrderAddedIndicator', true)
                    }
                    
                    currentTarget.text = 'Added';
                    currentTarget.className = 'disabled';
                    **/
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error mess2age: " + 
                                        errors[0].message);
                        }
                    }
                }
                    else{
                        console.log('Failed with stat2e: ' + state);
                    }
            });
            
            //send action to be executed
            $A.enqueueAction(action);
        }
    },
    deleteContentDocument : function(component, event, helper) {
debugger;
        var dealerContId = component.get('v.dealerContactId');
        var action = component.get('c.deleteContentDocument');
        action.setParams({ recordId : dealerContId});
        action.setCallback(this, function(response){
            debugger;
            var state = response.getState();
            console.log(response);
            var resp = response.getReturnValue();
            console.log(resp);
            if(state === "SUCCESS") {
               		//file deleted successfully
                }
        });
        
        //send action to be executed
        $A.enqueueAction(action);
        
    },

})