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
    }
})