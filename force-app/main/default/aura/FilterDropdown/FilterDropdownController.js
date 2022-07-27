({
    doInit : function(component, event, helper) {
       /* var action = component.get('c.getCategories');
        var mapper = component.get("v.mapper");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp!=null && resp.length > 0){
                    console.log('SUCCESS: getCategories');
                    var lst = [];
                    resp.forEach(function(item)
                                 {
                                     lst.push({label:item.Name, value:item.Id});
                                     mapper[item.Id] = item.Name;
                                     
                                 });
                     component.set("v.categoryOptions", lst);
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
        $A.enqueueAction(action);*/
        console.log('order');
        //List of Orders
        var action2 = component.get('c.getOrders');
        action2.setCallback(this, function(response){
            console.log('order2');
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('Success');
                console.log(JSON.stringify(resp));
                if(resp!=null && resp.length > 0){
                     component.set("v.draftOrderList", resp);
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
        $A.enqueueAction(action2);
    },
    
    handleChange:function (component, event, helper) {
       	var i = 0;
        
        //Selected Category Options Updated
        var a = component.find("categories").get("v.value");
        var renderedList = [];
       	a.forEach(function(item)
                    {
                        var v = 'categories' + '_' + i + '_' + item + '_'; //Setting Value in this way to help in removing from rendered List in a single step
                        renderedList.push({label:component.get("v.mapper")[item], value:v});
                        i++
                    });
        
        component.set("v.renderedList", renderedList);
    },
    
    Remove:function (component, event, helper) {
        var currentTarget = event.currentTarget;
        var renderedListId = currentTarget.getAttribute("data-renderedListId");
        
        var field = renderedListId.split('_')[0];
        var fieldIterator = parseInt(renderedListId.split('_')[1]);
        var ListIterator = parseInt(renderedListId.split('_')[3]);
        
        //Removing from Rendered List
        var renderedList = component.get("v.renderedList");
    	renderedList.splice(ListIterator, 1);
        component.set("v.renderedList", renderedList);
        
        //Unchecking from Attribute checkbox
        var valueSelected = component.find(field).get("v.value");
    	valueSelected.splice(fieldIterator, 1);
        component.find(field).set("v.value", valueSelected);
    },
    
    SaveList:function (component, event, helper) {
        component.set("v.showFilterList",true);
        /*
        var renderedList = component.get("v.renderedList");
        
        var action = component.get('c.CreateFilterList');
        action.setParams({ attributeList : JSON.stringify(renderedList)});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp!=null && resp == 'Success'){
                    console.log('SUCCESS: CreateFilterList');
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
        */
    },
    
    showPathFinder: function(component, event, helper) {
        component.set("v.showPathFinderComponent", true);
    },
    
    GetList:function (component, event, helper) {
        
        var action = component.get('c.GetFilterList');
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp!=null){
                    console.log('SUCCESS: GetFilterList');
                    var renderedList = JSON.parse(resp);
                    component.set("v.renderedList", renderedList);
                    var categories = [];
                    renderedList.forEach(function(item)
                    {
                        if(item.value.split('_')[0] == 'categories'){
                            categories.push(item.value.split('_')[2])
                        }
                        console.log(item.value);
                        
                    });
                    component.set("v.categoryValue", categories);
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
savedFilterCollapse : function(component, event, helper) {
        $(document).ready(function () {
			$('.saved-lists .saved-opener').on('click', function () {
				$(this).toggleClass('active');
				$(this).siblings('.dropdown').slideToggle();
			});
		});
    }
    
})