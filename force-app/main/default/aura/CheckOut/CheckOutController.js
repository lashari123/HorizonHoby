({
    init : function(component, event, helper) {
        var OrderID = helper.getUrlParameter(component,'oid');
        
        component.set('v.orderId',OrderID);
        
        var getOrderDetail = component.get('c.getOrderLineItemsDetails');
        getOrderDetail.setParams({ orderID : OrderID});
        
        getOrderDetail.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                debugger
                var data =JSON.parse(response.getReturnValue());
                component.set('v.orderData',data)
                
                var statusDiv = component.find('status')
                
                
                if(data.Name == '' || data.Name == null){
                    data.Name = 'My Order';
                }
            }
        });
        
        $A.enqueueAction(getOrderDetail);
        var locale = $A.get("$Locale.language");       
        
        if(locale != 'en'){
            helper.getTranslation(component, event, helper)
            
        }
    },
    onAuthorizeHandler : function(component, event, helper) {
        
        var OrderID = helper.getUrlParameter(component,'oid');
        var action = component.get("c.authorizedOrder");
        action.setParams({ orderID : OrderID});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var navService = component.find( "navService" );  
                
                var pageReference = {  
                    type: "comm__namedPage",  
                    attributes: {  
                        pageName: "order-confirmation"  
                    },  
                    state: {  
                        oid : OrderID,
                        
                
                    }  
                }; 
                
                navService.navigate( pageReference ); 
                
            }
        });
        
        $A.enqueueAction(action);
    }
})