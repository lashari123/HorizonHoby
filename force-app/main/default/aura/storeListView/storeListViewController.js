({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
           
            {label: 'Product name', fieldName: 'linkName', type: 'url', 
             typeAttributes: { label: { fieldName: 'Name' }, }},
            {label: 'Product Code', fieldName: 'ProductCode', type: 'text'},
            {label: 'Product Family', fieldName: 'Family', type: 'text'},
            
        ]);
            
            var action = cmp.get("c.getLists");
            action.setParams({ sObjectName : cmp.get("v.sObjectName"),
            filter : cmp.get("v.filter"),
            noOfRows : cmp.get("v.noOfRows")});
            action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
            var data =  response.getReturnValue();
            data.forEach(item =>{
            debugger
            	item.linkName = '/horizonhobby/s/product/'+item.Name+'/'+item.Id;
            });
            cmp.set("v.data", data);
            }
            });
            $A.enqueueAction(action);
            }
})