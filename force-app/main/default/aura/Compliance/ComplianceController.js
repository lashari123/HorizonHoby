({
	doInit : function(component, event, helper) {
        var action = component.get('c.getCompliance'); 
        
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
            setTimeout(function() { 
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
            }, 5000);
		});
	},
    
    showLearnMoreLinks  : function(component, event, helper) {
    var varLearnMore = component.find("learnMoreId");
    $A.util.addClass(varLearnMore, "clsShowLearnMore"); 
        
    var varBtnShow = component.find("BtnShow");
    $A.util.removeClass(varBtnShow, "clsShowButton"); 
    $A.util.removeClass(varBtnShow, "clsHideButton");   
    $A.util.addClass(varBtnShow, "clsHideButton");
        
    var varBtnHide = component.find("BtnHide");
    $A.util.removeClass(varBtnHide, "clsShowButton"); 
    $A.util.removeClass(varBtnHide, "clsHideButton");   
    $A.util.addClass(varBtnHide, "clsShowButton");        
    },
    
    
    hideLearnMoreLinks  : function(component, event, helper) {
    var divLearnMore = component.find("learnMoreId");
    $A.util.removeClass(divLearnMore, "clsShowLearnMore");   
        
    var varBtnShow = component.find("BtnShow");
    $A.util.removeClass(varBtnShow, "clsShowButton"); 
    $A.util.removeClass(varBtnShow, "clsHideButton");   
    $A.util.addClass(varBtnShow, "clsShowButton");
        
    var varBtnHide = component.find("BtnHide");
    $A.util.removeClass(varBtnHide, "clsShowButton"); 
    $A.util.removeClass(varBtnHide, "clsHideButton");   
    $A.util.addClass(varBtnHide, "clsHideButton");           
    }    
})