({
    doInit : function(component, event, helper) {
        var a = component.get('c.getListOfFilters');
        $A.enqueueAction(a);
    },
    
    deleteSavedList : function(component, event, helper) {
        var currentTarget = event.currentTarget;
        var filterId = currentTarget.getAttribute("data-filterId");
        
        var action = component.get('c.deleteSavedFilterList');
        
        action.setParams({ filterId : filterId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('SUCCESS: deleteSavedFilterList');
                var a = component.get('c.getListOfFilters');
        		$A.enqueueAction(a);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                }
            }
            else{
                console.log('Failed with state: ' + state);
            }
        });
        
        //send action to be executed
        $A.enqueueAction(action);
    },
    
    getListOfFilters : function(component, event, helper) {
        debugger;
        var action = component.get('c.getSavedFilterList');
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp!=null && resp.length > 0){
                    console.log('SUCCESS: getSavedFilterList');
                    var mapper = component.get("v.mapper");
                    debugger;
                    resp.forEach(function(item)
                                 {
                                     mapper[item.Id] = item.Name;
                                 });
                    component.set("v.savedFilterList", resp);
                    component.set("v.showSavedList", true);
                } else{
                    component.set("v.showSavedList", false);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                }
            }
            else{
                console.log('Failed with state: ' + state);
            }
        });
        
        //send action to be executed
        $A.enqueueAction(action);
    },
    
    Edit : function(component, event, helper) {
        var currentTarget = event.currentTarget;
        var filterId = currentTarget.getAttribute("data-filterId");
        
        var action = component.get('c.GetSelectedFilterList');
        action.setParams({ filterId : filterId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp!=null && resp.length>0){
                    console.log('SUCCESS: GetSelectedFilterList');
                    var renderedList = JSON.parse(resp[0].Attribute_List__c);
                    component.set("v.renderedList", renderedList);
                    component.set("v.name", resp[0].Name);
                    component.set("v.editListId", resp[0].Id);
                    component.set("v.showFilterList",true);
                    component.set("v.dropDownLabel", component.get("v.mapper")[filterId]);
                    /*var categories = [];
                    renderedList.forEach(function(item)
                    {
                        if(item.value.split('_')[0] == 'categories'){
                            categories.push(item.value.split('_')[2])
                        }
                        console.log(item.value);
                        
                    });
                    component.set("v.categoryValue", categories);*/
                    
                    
                    var compEvent = component.getEvent("RunFilterEvent");                        
        			compEvent.fire();
                    
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                }
            }
            else{
                console.log('Failed with state: ' + state);
            }
        });
        
        //send action to be executed
        $A.enqueueAction(action);
        
    },
    renderList: function(component, event, helper) {
        var currentTarget = event.currentTarget;
        var filterId = currentTarget.getAttribute("data-filterId");
        
        var action = component.get('c.GetSelectedFilterList');
        action.setParams({ filterId : filterId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp!=null && resp.length>0){
                    console.log('SUCCESS: GetSelectedFilterList');
                    var renderedList = JSON.parse(resp[0].Attribute_List__c);
                    component.set("v.renderedList", renderedList);
                    component.set("v.dropDownLabel", component.get("v.mapper")[filterId]);
                    component.set("v.filterListSelected", component.get("v.mapper")[filterId]);
                    
                    /*var categories = [];
                    renderedList.forEach(function(item)
                    {
                        if(item.value.split('_')[0] == 'categories'){
                            categories.push(item.value.split('_')[2])
                        }
                        console.log(item.value);
                        
                    });
                    component.set("v.categoryValue", categories);*/
                    
                    var compEvent = component.getEvent("RunFilterEvent");                        
        			compEvent.fire();
                  
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                }
            }
            else{
                console.log('Failed with state: ' + state);
            }
        });
        
        //send action to be executed
        $A.enqueueAction(action);
    },
    
    UpdateSavedFilterList : function(component, event, helper) {
        debugger;
            var a = component.get('c.getListOfFilters');
        	$A.enqueueAction(a);
    },
        
	savedFilterCollapse : function(component, event, helper) {
        $(document).ready(function () {
			$('.saved-lists .saved-opener').on('click', function () {
				$(this).toggleClass('active');
				$(this).siblings('.dropdown').slideToggle();
			});
		});
    }
})