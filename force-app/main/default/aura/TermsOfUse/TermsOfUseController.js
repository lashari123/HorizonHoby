({
	doInit : function(component, event, helper) {
        var action = component.get('c.getTermsofUse'); 
        
        action.setCallback(this, function(response){ 
            var state = response.getState(); 
            if(state === "SUCCESS") { 
                var resp = response.getReturnValue(); 
                console.log('SUCCESS'); 
                if (resp != null) { 
                    //component.set("v.complianceObject", resp); 
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
        
        $(document).ready(function () {
			setTimeout(function(){
                
                $(".accordion .btn-link").click(function(){
               /* $(this).siblings(".collapse").slideToggle();
				$(this).closest('.card').siblings().find('.collapse').slideUp();
				$(this).toggleClass('opener');
                $(this).closest('.card').siblings().find('.btn-link').removeClass('opener');
                */
				$(".btn-link").siblings(".collapse").slideToggle();
				$(".btn-link").closest('.card').siblings().find('.collapse').slideUp();
				$(".btn-link").toggleClass('opener');
                $(".btn-link").closest('.card').siblings().find('.btn-link').removeClass('opener');    
                    console.log('test...');
			});
			$(".accordion .multi-btn-link").click(function(){
				var linkId = $(this).attr('data-target');
				$(linkId).slideToggle();
			});
         }, 7000);
		});
	} 
})