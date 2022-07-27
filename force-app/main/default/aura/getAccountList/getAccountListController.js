({
	init: function (component, event, helper) {
        component.set('v.columns', [
            {label: 'Account Name', fieldName: 'linkName', type: 'url',
			typeAttributes: {label: { fieldName: 'Name' }, target: '_self'}},
            {label: 'Customer Number', fieldName: 'Customer_Number__pc', type: 'text'},
            {label: 'Channel', fieldName: 'Channel__pc', type: 'text'},
            {label: 'SFSC#', fieldName: 'Case_Safe_Contact_Id__pc', type: 'Id'}
         ]);

      var action = component.get("c.getAllAccounts");
       action.setParams({
            recordId:component.get("v.recordId")
            
        });
        
         action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state'+response.getState());
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                records.forEach(function(record){
                   record.linkName = '/'+record.Id;
                });
                component.set("v.accList", records);
            }
        });
        $A.enqueueAction(action);
 }
    
})