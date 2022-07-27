({
    doInit: function (component, event, helper) {
        
        var action = component.get("c.getDynamicContentHeader");
        action.setParams({
            contentName: 'Terms of Use'
            
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set("v.dynamicContent", records);
            }
        });
        
        $A.enqueueAction(action);
        
        var actionSection = component.get("c.getContentSection");
        actionSection.setParams({
            contentName: 'Terms of Use'
            
        });
        
        actionSection.setCallback(this, function(response){
            var stateSection = response.getState();
            
            if (stateSection === "SUCCESS") {
                var sectionRecords = response.getReturnValue();
                component.set("v.contentSections", sectionRecords);
            }
        });
        
        $A.enqueueAction(actionSection);  
        
        $(document).ready(function () {
            console.log('loaded...');
            $('.accordion-section-title').click(function(e){
                var currentAttrvalue = $(this).attr('href');
                if($(e.target).is('.active')){
                    $(this).removeClass('active');
                    $('.accordion-section-content:visible').slideUp(300);
                } else {
                    $('.accordion-section-title').removeClass('active').filter(this).addClass('active');
                    $('.accordion-section-content').slideUp(300).filter(currentAttrvalue).slideDown(300);
                }
            });
    setTimeout(function() { 
	$(".accordion_head").click(function(){
		if ($('.accordion_body').is(':visible')) {
			$(".accordion_body").slideUp(300);
			$(".plusminus").text('+');
		}
        if( $(this).next(".accordion_body").is(':visible')){
            $(this).next(".accordion_body").slideUp(300);
            $(this).children(".plusminus").text('+');
        }else {
            $(this).next(".accordion_body").slideDown(300); 
            $(this).children(".plusminus").text('-');
        }
	});   
     }, 5000);     
            
            
        });
    },
    
    handleBtnClick: function (component, event, helper) {
        console.log('button clicked...');
        $('.accordion-section-title').click(function(e){
            var currentAttrvalue = $(this).attr('href');
            
            //if($(e.target).is('.active'))
            if($(this).is('.active'))
            {
                $(this).removeClass('active');
                $('.accordion-section-content:visible').slideUp(300);
            } 
            else 
            {
                $('.accordion-section-title').removeClass('active').filter(this).addClass('active');
                $('.accordion-section-content').slideUp(300).filter(currentAttrvalue).slideDown(300);
            }
        });   
        
        


    },
    
    handleBtnClick2: function (component, event, helper) {
	$(".accordion_head").click(function(){
		if ($('.accordion_body').is(':visible')) {
			$(".accordion_body").slideUp(300);
			$(".plusminus").text('+');
            console.log(1);
		}
        else
        if( $(this).next(".accordion_body").is(':visible')){
            $(this).next(".accordion_body").slideUp(300);
            $(this).children(".plusminus").text('+');
            console.log(2);
        }else {
            $(this).next(".accordion_body").slideDown(300); 
            $(this).children(".plusminus").text('-');
            console.log(3);
        }
	}); 
    }
    
})