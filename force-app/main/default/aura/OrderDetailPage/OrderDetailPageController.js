({
    init : function(component, event, helper) {
        component.set('v.columns', [
            //    {label: 'imageLink', fieldName: 'PrimaryImageLink', type: 'text'},
            
            {label: 'Item', fieldName: 'linkName', type: 'url',  typeAttributes: {label: { fieldName: 'ProductName' }, target: '_blank', required: true }},
            {
                label: 'QTY', fieldName: 'Quantity', type: 'number', editable: true,    
                
            },
            {label: 'Description', fieldName: 'Description', type: 'text'},
            
            {label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency', typeAttributes: { currencyCode: 'USD'},  typeAttributes: { required: true }, } ,
            {label: 'Total', fieldName: 'TotalPrice', type: 'currency', typeAttributes: { currencyCode: 'USD'}, typeAttributes: { required: true} },
            {label: 'BO', fieldName: 'Avail__c', type: 'text'},
            {label: 'Opened', fieldName: 'Opened__c', type: 'text'},
            {label: 'Fulfilled', fieldName: 'Fulfilled__c', type: 'text'},
            {label: 'Cancelled', fieldName: 'Cancelled__c', type: 'text'},
            {label: 'Note', fieldName: 'Rank__c', type: 'text'}
            
            
            
            
        ]); 
        
        var OrderID = helper.getUrlParameter(component,'oid');
        
        component.set('v.orderId',OrderID);
        
        var action2 = component.get('c.getOrderLineItems');
        action2.setParams({ orderID : OrderID});
        
        action2.setCallback(this, function(response){
            console.log('getOrderLineItems');
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('Success');
                console.log(JSON.parse(resp));
                if(resp!=null && resp.length > 0){
                    
                    var map = {"opened": 0 ,"fulfilled": 0 , "cancelled" :0,"total" : 0}
                    component.set("v.data", JSON.parse(resp));
                    var data = JSON.parse(resp)
                    data.forEach(function(item)
                                 {
                                    map["total"] += item.Quantity
                                    map["opened"] += item.opened__c == undefined ? 0 : item.opened__c
                                    map["fulfilled"] += item.fulfilled__c== undefined ? 0 : item.fulfilled__c
                                    map["cancelled"] += item.Cancelled__c== undefined ? 0 : item.Cancelled__c
                                 },this);
              
                    console.log(map)
                    component.set("v.countMap", map);
                    
                

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
        $A.enqueueAction(action2);
        
        
        
        
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
    },
    
    openModal : function(component, event, helper) {
        
                    component.set("v.showPrintModal",true) ;
            
            component.set("v.isExcel",true) 
        
    },
    
     print : function(component, event, helper){
        //window.print()
        //
        var navService = component.find( "navService" );  
        var FilterId = component.get("v.FilterId")
        var keyword= component.get( "v.keyword" ); 
        var Category= component.get( "v.categorySelectedValue" ); 
        var Maufacture= component.get( "v.manufacturerSelectedValue" ); 
        var all = 'true';
        if(event.target.id != 'all'){
            all = 'false'
        }
        var pageReference = {  
            type: "comm__namedPage",  
            attributes: {  
                pageName: "printhtml"  
            },  
            state: {  
                FilterId : FilterId,
                keyword : keyword,
                category : Category,
                maufacture :Maufacture,
                all: all,
                start : ''+component.get("v.start"),
                end : ''+component.get("v.end"),
                table :'orderSumary'
                
            }  
        }; 
        
        //      navService.navigate( pageReference ); 
        navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            window.open(url, "_blank");
        }), $A.getCallback(function(error) {
            cmp.set("v.url", defaultUrl);
        }));  
         component.set("v.showPrintModal",false)

    },
    
     closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showPrintModal", false);
    },
})