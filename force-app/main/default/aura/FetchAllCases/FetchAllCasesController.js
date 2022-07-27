({
	init: function (component, event, helper) {
        component.set('v.columns', [
            {label: 'Case Number', fieldName: 'linkName', type: 'url',
			typeAttributes: {label: { fieldName: 'CaseNumber' }, target: '_self'}},
            {label: 'Case Reason', fieldName: 'Reason', type: 'text'},
             {label: 'Open Date', fieldName: 'CreatedDate',type: 'date-local', sortable:true},
             {label: 'Close Date', fieldName: 'ClosedDate', type: 'date-local', sortable:true},
            {label: 'Status', fieldName: 'Status', type: 'text'},
            {label: 'Department', fieldName: 'Department__c', type: 'text'},
            {label: 'Case Channel', fieldName: 'Channel__c', type: 'text'},
            {label: 'Customer Channel', fieldName: 'Customer_Channel__c', type: 'text'},
             
         ]);

      var action = component.get("c.getAllCases");
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
                component.set("v.caseList", records);
            }
        });
        $A.enqueueAction(action);
 }
    
})