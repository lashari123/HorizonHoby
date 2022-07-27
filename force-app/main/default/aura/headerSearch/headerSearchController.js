({
    init: function (cmp, event, helper) {
        
        
        
        
        var action = cmp.get("c.getCategories");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS'){
                var CategoryList = response.getReturnValue();
                if(CategoryList.length > 0){
                    cmp.set("v.categoryList",CategoryList);
                }
                
            }
        });
        $A.enqueueAction(action); 
        
        //Getting Manufacturers for Manufacturer Filter Dropdown
        var action = cmp.get("c.getManufacturers");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS'){
                var manufacturerList = response.getReturnValue();
                if(manufacturerList.length > 0){
                    cmp.set("v.manufacturerList",manufacturerList);
                }
            }
        });
        $A.enqueueAction(action); 
        
    },
    filter:function (component, event, helper) {
        event.preventDefault();
        var category = component.find('category').getElements()[0].value
        var keyword = component.find('keyword').getElements()[0].value
        var manufacturer = component.find('manufacture').getElements()[0].value
        var navService = component.find( "navService" );  
        var pageReference = {  
            type: "comm__namedPage",  
            attributes: {  
                pageName: "results"  
            },  
            state: {  
                keyword :keyword,
                category: category,
                manufacturer:manufacturer
            }  
        };  
        
        sessionStorage.setItem( 'pageTransfer', JSON.stringify( pageReference.state ) );  
        console.log( 'State is ' + pageReference.state );
        navService.navigate( pageReference );  
        
    }
    
})