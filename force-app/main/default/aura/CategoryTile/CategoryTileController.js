({
	doInit : function(component, event, helper) {

        var locale = $A.get("$Locale.language");
        if(locale == 'de'){
            
            component.set('v.title','Kategorien')
        }
        else if (locale == 'fr'){
            component.set('v.title','Catégories')
        }
		 var action = component.get('c.getAllCategories');
            
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if (resp != null && resp.length >= 0) {
                    component.set("v.categories", resp);
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
    search : function(component, event, helper) {
       var category = event.currentTarget.id;
        
        var navService = component.find( "navService" );  
        var pageReference = {  
            type: "comm__namedPage",  
            attributes: {  
                pageName: "results"  
            },  
            state: {  
                category: category
            }  
        };  
        
        sessionStorage.setItem( 'pageTransfer', JSON.stringify( pageReference.state ) );  
        console.log( 'State is ' + pageReference.state );
        navService.navigate( pageReference );  
}
})