({
	doInit : function(component, event, helper) {
       /* var action = component.get('c.getPrivacy'); 
        
        action.setCallback(this, function(response){ 
            var state = response.getState(); 
            if(state === "SUCCESS") { 
                var resp = response.getReturnValue(); 
                console.log('SUCCESS: getPrivacy'); 
                if (resp != null) { 
                   // component.set("v.imprintObject", resp); 
                    component.set("v.test", resp);
                } 
            } else if (state === "ERROR") { 
                var errors = response.getError(); 
                if (errors) { 
                    if (errors[0] && errors[0].message) { 
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
        */
        var locale = $A.get("$Locale.language");
		component.set("v.lang", 'English');
        if(locale == 'de'){
            component.set("v.lang", 'German');
        } else if(locale == 'fr') {
           	component.set("v.lang", 'French');
        }
        
        
        $(document).ready(function () {
			$(".accordion .btn-link").click(function(){
				$(this).siblings(".collapse").slideToggle();
				$(this).closest('.card').siblings().find('.collapse').slideUp();
				$(this).toggleClass('opener');
                $(this).closest('.card').siblings().find('.btn-link').removeClass('opener');
			});
			$(".accordion .multi-btn-link").click(function(){
				var linkId = $(this).attr('data-target');
				$(linkId).slideToggle();
			});
		});
	}
})