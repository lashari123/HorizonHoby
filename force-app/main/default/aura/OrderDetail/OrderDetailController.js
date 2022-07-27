({
	init: function (component, event, helper) {
        component.set('v.columns', [
            {label: 'Order#', fieldName: 'OrderId', type: 'url',
            typeAttributes: {label: { fieldName: 'OrderNumber' }, target: '_self'}},
            {label: 'Source', fieldName: 'SiteId', type: 'text'},
            {label: 'Order Status', fieldName: 'Status', type: 'text'},
            {label: 'Order Date', fieldName: 'OrderTimestamp', type: 'date'},
            {label: 'Customer Name', fieldName: 'contDetails', type: 'url',
            typeAttributes: {label: { fieldName: 'Name' }, target: '_self'}}
        ]);
        console.log('recordId'+component.get("v.recordId"));
        component.set("v.isLoading", true);
        var action = component.get("c.calloutToGoServer");
        action.setParams({
            recordId:component.get("v.recordId")
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state'+response.getState());
            if (state === "SUCCESS") {
                 component.set("v.isLoading", false);
                var records =response.getReturnValue();
                records.forEach(function(record){
                   record.OrderNumber = record.OrderNumber;
                  // record.OrderId = '/'+record.OrderId;
                   record.OrderId = '/lightning/r/Orders__x/'+record.OrderId+'/view';
                   record.Name = record.contName;
                   record.contDetails = '/'+record.ContactId;
                });
                component.set("v.data", records);
                console.log('data@@'+JSON.stringify(component.get("v.data")));
            }
        });
        $A.enqueueAction(action);
    }
})