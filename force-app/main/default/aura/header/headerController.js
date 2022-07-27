({
    doInit : function(component, event, helper) {
        var action = component.get('c.setLanguagetoDefault');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if (resp != null && resp== 'changed') {
                    console.log('Set Language to Default SUCCESS');
                    //$A.get('e.force:refreshView').fire();
                    location.reload();
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
                }
        });
        
        //send action to be executed
        $A.enqueueAction(action);
        var action1 = component.get('c.getFilterList');
        action1.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
               component.set("v.filterList",resp);
                
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
                }
        });
        
        //send action to be executed
        $A.enqueueAction(action1);
        
        //get montly sale:
        var action2 = component.get('c.getMonthlySales');
        action2.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp.MonthlySale!=null){
                    component.set('v.monthlySale', resp.MonthlySale);
                    component.set('v.saleColor', resp.SaleColor);
                    //component.set('v.monthlySale', resp.MonthlySale);
                    
                }
                console.log(resp);
                
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
                }
        });
        
        //send action to be executed
        $A.enqueueAction(action2);
    },
    handleAfterScriptsLoaded : function(component, event, helper) {
        $(document).ready(function () {
            $('.btn-nav, .btn-nav-close').on('click', function () {
                $('#header').toggleClass('nav-active');
            });
            $('.btn-search').on('click', function () {
                $('#header').toggleClass('search-active');
                $(this).siblings('.search-form').slideToggle();
            });
            $('#nav > li > a').on('click', function () {
                $(this).closest('.dropdown').toggleClass('active');
                $(this).siblings('.nav-dropdown').slideToggle();
            });
        });
    },
    
    logout: function(component, event, helper) {
        //window.location.href= 'https://b2bdev-horizonhobbysupport.cs166.force.com/secur/logout.jsp';
       // window.location.href= 'logout.jsp?retUrl=https://b2bdev-horizonhobbysupport.cs166.force.com/horizonhobby/CommunitiesLanding';
        window.location.replace("https://b2bdev-horizonhobbysupport.cs166.force.com/horizonhobby/secur/logout.jsp?retUrl=https://b2bdev-horizonhobbysupport.cs166.force.com/horizonhobby/CommunitiesLanding");
    },
    
    showPathFinder: function(component, event, helper) {
        component.set("v.showPathFinderComponent", true);
    },
    
    
    search:function(component, event, helper) {
        var id = event.currentTarget.getAttribute('id');
         var navService = component.find( "navService" );  
           var pageReference = {  
            type: "comm__namedPage",  
            attributes: {  
                pageName: "results"  
            },  
            state: {  
                FilterId :id
            }  
        };  
        
        navService.navigate( pageReference );  
        
    }
})