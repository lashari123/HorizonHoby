({
	 doInit : function(component, event, helper) {
         var a = component.get('c.getListOfOrders');
         $A.enqueueAction(a); 

         
         var skuQuantityList = component.get("v.skuQuantityList");
         var lst = [];
         if(skuQuantityList != null && skuQuantityList!= undefined && skuQuantityList.length>0){
             for (var i=0; i<skuQuantityList.length; i++) {
                 let sku = skuQuantityList[i].split('_')[0];
                 let quantity = skuQuantityList[i].split('_')[1];
                 lst.push({sku:sku, quantity:quantity});
             }
             component.set("v.skuQuantities", lst);
         }
    },
    
    Add:function (component, event, helper) {
        debugger;
        var FromImportOrderLine = component.get("v.FromImportOrderLine");
        var FromAllOrderPage = component.get("v.FromAllOrderPage");
        
        var currentTarget = event.currentTarget;
        var orderId = currentTarget.getAttribute("data-orderId");
		var text = currentTarget.text;
        if(text != 'Added'){
        var skuQuantityList = component.get("v.skuQuantityList");
        var skuQuantityListString=JSON.stringify(skuQuantityList);
        
        var action = component.get('c.addOrderItem');
        action.setParams({ skuQuantityListString : skuQuantityListString,
                          orderId : orderId});
            
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('SUCCESS: Products Added to the Selected Order');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Products Added to the Selected Order"
                });
                toastEvent.fire();
                
                //take the dealer to all orderpage:
                if(FromAllOrderPage==true){
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/order-summary"
                    });
                    urlEvent.fire();
                }
                //take the dealer to cart page:
                else if(FromImportOrderLine==true){
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/cart/?oid="+orderId
                    });
                    urlEvent.fire();
                }
                // Event fired when it is called from cart page (Move to Existing Order)
                // Event fired so that all the line items that are moved are deleted from respective draft order
                if(component.get("v.onlyDraftOrder")){
                    component.set('v.singleDraftOrderAddedIndicator', true)
                }
                
                currentTarget.text = 'Added';
                currentTarget.className = 'disabled';
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
    
    addProductsToNewOrder:function (component, event, helper) {
        var FromImportOrderLine = component.get("v.FromImportOrderLine");
        var FromAllOrderPage = component.get("v.FromAllOrderPage");
        
        var skuQuantityList = component.get("v.skuQuantityList");
        var skuQuantityListString=JSON.stringify(skuQuantityList);
        var action = component.get('c.addToNewOrder');
        action.setParams({ skuQuantityListString : skuQuantityListString});
            
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                debugger;
                if (resp != null) {
                    var orderId= resp;
                    var orderList = component.get("v.orderList");
                    //orderList.push(resp);
                    //component.set("v.orderList", orderList);
                    console.log(resp);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Products Added to the New Order"
                    });
                    toastEvent.fire();
                    
                    //take the dealer to all orderpage:
                    if(FromAllOrderPage==true){
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "/order-summary"
                        });
                        urlEvent.fire();
                    }
                    //take the dealer to cart page:
                    else if(FromImportOrderLine==true){
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "/cart/?oid="+orderId
                        });
                        urlEvent.fire();
                    }
                    // Event fired when it is called from cart page (Move to New Order)
                    // Event fired so that all the line items that are moved are deleted from respective draft order
                    if(component.get("v.onlyNewOrder")){
                        var compEvent = component.getEvent("DeleteOrderLineItemEvent");                        
                        compEvent.fire();
                    }
                    
                    component.set("v.loaded", true);
                    window.setTimeout(
                        $A.getCallback(function() {
                            component.set("v.loaded", false);
                            var a = component.get('c.getListOfOrders');
                            $A.enqueueAction(a);
                        }), 2000
                    );
                   
                    
                    event.getSource().set("v.label","Created")
                    component.set("v.isCreated", true);
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
    
    getListOfOrders : function(component, event, helper) {
        var action = component.get('c.getAllOrders');
            
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if (resp != null && resp.length >= 0) {
                    console.log('SUCCESS: getAllOrders');
                    //console.log(JSON.parse(resp.JSON));
                    component.set("v.orderList", resp);
                    console.log(resp[0]);
                    /*var a = component.get("v.orderList");
                    console.log(a.length);
                    a.push(a[0]);
                    component.set("v.orderList", a);
                    var b = component.get("v.orderList");
                    console.log(b.length);*/
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
                console.log(response.getReturnValue());
                console.log('Failed with state: ' + state);
            }
        });
        
        //send action to be executed
        $A.enqueueAction(action);
        
    },
    cancelAction : function(component, event, helper) {
        if(component.get('v.fromCatalogSearch')){
            var compEvent = component.getEvent("RunFilterEvent");                        
            compEvent.fire();
        }
        if(component.get('v.singleDraftOrderAddedIndicator')){
            var compEvent = component.getEvent("DeleteOrderLineItemEvent");                        
            compEvent.fire();
        }
        if(component.get('v.isHomePage')){
            component.set("v.skuQuantityList", []);
        }
        
        component.set("v.show", false);
        
    },
    closeModal : function(component, event, helper){
        event.stopPropagation();
    },
   
})