({
    init: function (cmp, event, helper) {
        
        var newreleaseColumns=  [
            
            //   {label: 'SKU', fieldName: 'stockKeepingUnit', type: 'text'},
            {label: 'Item', fieldName: 'linkName', type: 'url', 
             typeAttributes: { label: { fieldName: 'name' }, }},
            {label: 'Description', fieldName: 'description', type: 'text'},
            {label: 'Retail', fieldName: 'retail', type: 'currency'},
            {label: 'Dealer', fieldName: 'dealer', type: 'currency'},
            {label: 'ETA', fieldName: 'releaseDate', type: 'text'}            
            
        ];
        
        var topsellingColumns = [
            
            
            {label: 'Item', fieldName: 'linkName', type: 'url', 
             typeAttributes: { label: { fieldName: 'name' }, }},
            {label: 'Description', fieldName: 'description', type: 'text'},
            {label: 'Retail', fieldName: 'retail', type: 'currency'},
            {label: 'Dealer', fieldName: 'dealer', type: 'currency'}      
            
        ]
        
        cmp.set('v.newreleaseColumns',newreleaseColumns);
        cmp.set('v.topsellingColumns', topsellingColumns);        
        
        var locale = $A.get("$Locale.language");
        
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        
        var action = cmp.get("c.isPrice");
        action.setParams({userId :userId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                cmp.set("v.isPrice",response.getReturnValue());
                
                if(response.getReturnValue() == false){
                    var newreleaseColumns=   cmp.get('v.newreleaseColumns');
                    var topsellingColumns=  cmp.get('v.topsellingColumns');     
                    newreleaseColumns.splice(3, 1);
                    topsellingColumns.splice(3, 1);
                    cmp.set('v.newreleaseColumns',newreleaseColumns);
                    cmp.set('v.topsellingColumns', topsellingColumns);     
                }
                
                helper.getNewReleaseList(cmp, event, helper);
                
                helper.getTopSellingList(cmp, event, helper);
                
                helper.getNewStockList(cmp, event, helper);
            }
            
        })
        
        $A.enqueueAction(action);
        
        // helper.getColumns(cmp, event, helper);
        
        if(locale != 'en'){
            helper.getTranslations(cmp, event, helper)
            
        }
        
        
        
        
        
        
    }   ,     
    
    viewAllhandler : function (cmp, event, helper) {
        
        var tabName = event.currentTarget.name
        var filterID = ''
        var action = cmp.get("c.getFilterIdByName");
        action.setParams({name :tabName});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                filterID = response.getReturnValue();
                
                var navService = cmp.find("navService");
                var pageReference = {
                    
                    type: "comm__namedPage",
                    attributes: {
                        name: "results__c"
                    },
                    state: {
                        "FilterId": filterID
                    }
                };
                cmp.set("v.pageReference", pageReference);
                var defaultUrl = "#";
                navService.generateUrl(pageReference)
                .then($A.getCallback(function(url) {
                    cmp.set("v.url", url ? url : defaultUrl);
                }), $A.getCallback(function(error) {
                    cmp.set("v.url", defaultUrl);
                }));
                navService.navigate(pageReference);
                /*  var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/results'
        });
        urlEvent.fire();*/
            }
            
        })
        
        $A.enqueueAction(action);
        
        
        
    }
    
    
    
    
    
})