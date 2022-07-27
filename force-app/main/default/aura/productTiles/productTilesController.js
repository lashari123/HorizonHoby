({
	doInit : function(component, event, helper) {
        
        var locale = $A.get("$Locale.language");
        if(locale == 'de'){
            
            component.set('v.title','Meistverkaufte Produkte')
        }
        else if (locale == 'fr'){
            component.set('v.title','Produits les plus vendus')
        }
        var action = component.get('c.TopSellingProducts');
            
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                debugger;
                if (resp != null && resp.length > 0) {
                    component.set("v.PricebookEntryList", resp);
                    var topSellingProduct = component.get('v.PricebookEntryList');
                    /*for(i=0; i<topSellingProduct.length; i++){
                        alert(topSellingProduct[i].Product2.Description)
                    }*/
                    topSellingProduct.forEach( product=> {
                       product.Product2.Description = product.Product2.Description.substring(0,255);
                        
                    });
                        component.set("v.PricebookEntryList", topSellingProduct);
                } else {
                    console.log("No Top Selling Products Found");
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
         
         
    }
})