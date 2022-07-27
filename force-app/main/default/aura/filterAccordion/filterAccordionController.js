({
    doInit : function(component, event, helper) {
        //alert(component.get("v.filteredProductList").length);
      /*  window.setTimeout(
            $A.getCallback(function() {*/
                //alert(component.get("v.filteredProductList").length);
                if(component.get("v.filteredProductList").length==0){
                    var a = component.get('c.getFilterCheckboxValues');
                    $A.enqueueAction(a);
                } else {
                    var a = component.get('c.getFilterCheckboxValuesAndCount');
                    $A.enqueueAction(a);
                }
               /* var b = component.get('c.filterAccordion');
        		$A.enqueueAction(b);*/
           /* }), 6000
        );*/
        
        
        
    },
    
    update : function(component, event, helper) {
        console.log("test");
        var params = event.getParam('arguments');
       /* var field = event.getParam("field");
        var fieldIterator = event.getParam("fieldIterator");*/
        if(params){
            var field = params.field;
            var fieldIterator = params.fieldIterator;
            var valueSelected = component.find(field).get("v.value");
            valueSelected.splice(fieldIterator, 1);
            component.find(field).set("v.value", valueSelected);
        }
        
        
    },
    
    
    
    getFilterCheckboxValuesAndCount : function(component, event, helper) {
        
        var mapper = component.get("v.mapper");
        var action = component.get('c.getFilteredCheckboxValues');
        var prodList = component.get("v.filteredProductList");
        action.setParams({ prodList : prodList});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp!=null){
                    console.log('SUCCESS: getFilteredCheckboxValues');
                    var lst = [];
                    
                    //Adding Category Checkbox Values
                    var categoryResp = resp.prodCatFiltered;
                    categoryResp.forEach(function(item)
                                         {
                                             var l = item.split('_')[1];
                                             var v = item.split('_')[0];
                                             lst.push({label:l, value:v});
                                             mapper[v] = l;
                                             
                                         });
                    component.set("v.categoryOptions", lst);
                    if(component.get("v.categoryOptions").length == 0){
                        component.set("v.IsCat", false);
                    } else if(component.get("v.categoryOptions").length < 6){
                        component.set("v.IsCatMore", false);
                    }
                    //Adding Manufacture Checkbox Values
                    lst = [];
                    var manufacturerResp = resp.manufacturersFiltered;
                    manufacturerResp.forEach(function(item)
                                 {
                                     var l = item.split('_')[1];
                                     var v = item.split('_')[0];
                                     lst.push({label:l, value:v});
                                     mapper[v] = l;
                                 });
                     component.set("v.manufacturerOptions", lst);
                    if(component.get("v.manufacturerOptions").length == 0){
                        component.set("v.IsMan", false);
                    } else if(component.get("v.manufacturerOptions").length < 6){
                        component.set("v.IsManMore", false);
                    }
                    
                    //Adding Retail Price Checkbox Values
                    lst = [];
                    var retailPriceResp = resp.priceBracket;
                    retailPriceResp.forEach(function(item)
                                 {
                                     var l = item.split('_')[1];
                                     var v = item.split('_')[0];
                                     lst.push({label:l, value:v});
                                     mapper[v] = l;
                                 });
                     component.set("v.retailPriceOptions", lst);
                    if(component.get("v.retailPriceOptions").length == 0){
                        component.set("v.IsRetailP", false);
                    } else if(component.get("v.retailPriceOptions").length < 6){
                        component.set("v.IsRetailPMore", false);
                    }
                    
                    //Adding Completion Level Checkbox Values
                    lst = [];
                    var completionLevelResp = resp.completionLevelWrapper;
                    completionLevelResp.forEach(function(item)
                                 {
                                     var l = item.split('_')[1];
                                     var v = item.split('_')[0];
                                     lst.push({label:l, value:v});
                                     mapper[v] = l;
                                 });
                     component.set("v.completionLevelOptions", lst);
                    if(component.get("v.completionLevelOptions").length == 0){
                        component.set("v.IsComLevel", false);
                    } else if(component.get("v.completionLevelOptions").length < 6){
                        component.set("v.IsComLevelMore", false);
                    }
                    
                    //Adding Scale Checkbox Values
                    lst = [];
                    var scaleResp = resp.scaleWrapper;
                    scaleResp.forEach(function(item)
                                 {
                                     var l = item.split('_')[1];
                                     var v = item.split('_')[0];
                                     lst.push({label:l, value:v});
                                     mapper[v] = l;
                                 });
                     component.set("v.scaleOptions", lst);
                    if(component.get("v.scaleOptions").length == 0){
                        component.set("v.IsScale", false);
                    } else if(component.get("v.scaleOptions").length < 6){
                        component.set("v.IsScaleMore", false);
                    }
                    
                    //Adding Skill Level Checkbox Values
                    lst = [];
                    var skillLevelResp = resp.skillLevelWrapper;
                    skillLevelResp.forEach(function(item)
                                 {
                                     var l = item.split('_')[1];
                                     var v = item.split('_')[0];
                                     lst.push({label:l, value:v});
                                     mapper[v] = l;
                                     
                                 });
                     component.set("v.skillLevelOptions", lst);
                    if(component.get("v.skillLevelOptions").length == 0){
                        component.set("v.IsSkLevel", false);
                    }
                    
                    //Adding Power Type Checkbox Values
                    lst = [];
                    var powerTypeResp = resp.powerTypeWrapper;
                    powerTypeResp.forEach(function(item)
                                 {
                                     var l = item.split('_')[1];
                                     var v = item.split('_')[0];
                                     lst.push({label:l, value:v});
                                     mapper[v] = l;
                                     
                                 });
                     component.set("v.powerTypeOptions", lst);
                    
                    if(component.get("v.powerTypeOptions").length == 0){
                        component.set("v.IsPoTyp", false);
                    } else if(component.get("v.powerTypeOptions").length < 6){
                        component.set("v.IsPoTypMore", false);
                    }
                    
                    //Adding Status Checkbox Values
                    lst = [];
                    var statusResp = resp.statusWrapper;
                    statusResp.forEach(function(item)
                                 {
                                     var l = item.split('_')[1];
                                     var v = item.split('_')[0];
                                     lst.push({label:l, value:v});
                                     mapper[v] = l;
                                     
                                 });
                     component.set("v.statusOptions", lst);
                    if(component.get("v.statusOptions").length == 0){
                        component.set("v.IsSt", false);
                    }
                    
                    //Adding Vehicle Type Checkbox Values
                    lst = [];
                    var vehicleTypeResp = resp.vehicleTypeWrapper;
                    vehicleTypeResp.forEach(function(item)
                                 {
                                     var l = item.split('_')[1];
                                     var v = item.split('_')[0];
                                     lst.push({label:l, value:v});
                                     mapper[v] = l;
                                     
                                 });
                     component.set("v.vehicleTypeOptions", lst);
                    if(component.get("v.vehicleTypeOptions").length == 0){
                        component.set("v.IsVehTyp", false);
                    } else if(component.get("v.vehicleTypeOptions").length < 6){
                        component.set("v.IsVehTypMore", false);
                    }
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
    
    
    
    getFilterCheckboxValues : function(component, event, helper) {
        var action = component.get('c.getCheckboxValues');
        var mapper = component.get("v.mapper");
        var size = 5;
       // action.setParams({ size : size});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp!=null){
                    console.log('SUCCESS: getCheckboxValues');
                    var lst = [];
                    
                    //Adding Category Checkbox Values
                    var categoryResp = resp.prodCat;
                    categoryResp.forEach(function(item)
                                 {
                                     lst.push({label:item.Name, value:item.Id});
                                     mapper[item.Id] = item.Name;
                                     
                                 });
                     component.set("v.categoryOptions", lst);
                    
                    //Adding Manufacture Checkbox Values
                    lst = [];
                    var manufacturerResp = resp.manufacturers;
                    manufacturerResp.forEach(function(item)
                                 {
                                     lst.push({label:item.Name, value:item.Id});
                                     mapper[item.Id] = item.Name;
                                     
                                 });
                     component.set("v.manufacturerOptions", lst);
                    
                    //Adding Retail Price Checkbox Values
                    lst = [];
                    var retailPriceResp = resp.priceBracket;
                    retailPriceResp.forEach(function(item)
                                 {
                                     lst.push({label:item, value:item});
                                     mapper[item] = item;
                                     
                                 });
                     component.set("v.retailPriceOptions", lst);
                    
                    //Adding Completion Level Checkbox Values
                    lst = [];
                    var completionLevelResp = resp.completionLevelWrapper;
                    completionLevelResp.forEach(function(item)
                                 {
                                     lst.push({label:item, value:item});
                                     mapper[item] = item;
                                     
                                 });
                     component.set("v.completionLevelOptions", lst);
                    
                    //Adding Scale Checkbox Values
                    lst = [];
                    var scaleResp = resp.scaleWrapper;
                    scaleResp.forEach(function(item)
                                 {
                                     lst.push({label:item, value:item});
                                     mapper[item] = item;
                                     
                                 });
                     component.set("v.scaleOptions", lst);
                    
                    //Adding Skill Level Checkbox Values
                    lst = [];
                    var skillLevelResp = resp.skillLevelWrapper;
                    skillLevelResp.forEach(function(item)
                                 {
                                     lst.push({label:item, value:item});
                                     mapper[item] = item;
                                     
                                 });
                     component.set("v.skillLevelOptions", lst);
                    
                    //Adding Power Type Checkbox Values
                    lst = [];
                    var powerTypeResp = resp.powerTypeWrapper;
                    powerTypeResp.forEach(function(item)
                                 {
                                     lst.push({label:item, value:item});
                                     mapper[item] = item;
                                     
                                 });
                     component.set("v.powerTypeOptions", lst);
                    
                    //Adding Status Checkbox Values
                    lst = [];
                    var statusResp = resp.statusWrapper;
                    statusResp.forEach(function(item)
                                 {
                                     lst.push({label:item, value:item});
                                     mapper[item] = item;
                                     
                                 });
                     component.set("v.statusOptions", lst);
                    
                    //Adding Vehicle Type Checkbox Values
                    lst = [];
                    var vehicleTypeResp = resp.vehicleTypeWrapper;
                    vehicleTypeResp.forEach(function(item)
                                 {
                                     lst.push({label:item, value:item});
                                     mapper[item] = item;
                                     
                                 });
                     component.set("v.vehicleTypeOptions", lst);
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
    
    getMoreCategories : function(component, event, helper) {
        var size = component.get("v.categorySize");
        size = size + 5;
        component.set("v.categorySize", size);
        
        if(component.get("v.filteredProductList").length==0){
            var action = component.get('c.getCategoriesCheckboxValues');
            var mapper = component.get("v.mapper");
            
            action.setParams({ size : size});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getCategoriesCheckboxValues');
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
            $A.enqueueAction(action);
        } else {
            var action = component.get('c.getFilteredCategoriesCheckboxValues');
            var mapper = component.get("v.mapper");
            var prodList = component.get("v.filteredProductList");
            
            action.setParams({ size : size,
                               prodList : prodList});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getFilteredCategoriesCheckboxValues (Resp Length) '+ resp.length);
                        var lst = [];
                        //Adding Category Checkbox Values
                        var categoryResp = resp;
                        categoryResp.forEach(function(item)
                                             {
                                                 var l = item.split('_')[1];
                                                 var v = item.split('_')[0];
                                                 lst.push({label:l, value:v});
                                                 mapper[v] = l;
                                                 
                                             });
                        component.set("v.categoryOptions", lst);
                        if(component.get("v.categoryOptions").length < size + 1){
                        	component.set("v.IsCatMore", false);
                    	}
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
        }
        
        
    },
    
    getMoreManufacturers : function(component, event, helper) {
        debugger;
        var size = component.get("v.manufacturerSize");
        size = size + 5;
        component.set("v.manufacturerSize", size);
        
        if(component.get("v.filteredProductList").length==0){
            var action = component.get('c.getManufacturerCheckboxValues');
            var mapper = component.get("v.mapper");
            
            action.setParams({ size : size});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getManufacturerCheckboxValues');
                        var lst = [];
                        resp.forEach(function(item)
                                     {
                                         lst.push({label:item.Name, value:item.Id});
                                         mapper[item.Id] = item.Name;
                                         
                                     });
                         component.set("v.manufacturerOptions", lst);
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
        } else {
            var action = component.get('c.getFilteredManufacturerCheckboxValues');
            var mapper = component.get("v.mapper");
            var prodList = component.get("v.filteredProductList");
            
            action.setParams({ size : size,
                               prodList : prodList});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getFilteredManufacturerCheckboxValues (Resp Length) '+ resp.length);
                        var lst = [];
                        //Adding Category Checkbox Values
                        var categoryResp = resp;
                        categoryResp.forEach(function(item)
                                             {
                                                 var l = item.split('_')[1];
                                                 var v = item.split('_')[0];
                                                 lst.push({label:l, value:v});
                                                 mapper[v] = l;
                                                 
                                             });
                        component.set("v.manufacturerOptions", lst);
                        if(component.get("v.manufacturerOptions").length < size + 1){
                        	component.set("v.IsManMore", false);
                    	}
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
        }
        
        
    },
    
    getMoreRetailPrices : function(component, event, helper) {
        var size = component.get("v.retailPriceSize");
        size = size + 5;
        component.set("v.retailPriceSize", size);
        
        if(component.get("v.filteredProductList").length==0){
            var action = component.get('c.getRetailPriceCheckboxValues');
            var mapper = component.get("v.mapper");
            
            action.setParams({ size : size});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getRetailPriceCheckboxValues');
                        var lst = [];
                        resp.forEach(function(item)
                                     {
                                         lst.push({label:item, value:item});
                                         mapper[item] = item;
                                         
                                     });
                         component.set("v.retailPriceOptions", lst);
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
        } else {
            var action = component.get('c.getFilteredRetailPriceCheckboxValues');
            var mapper = component.get("v.mapper");
            var prodList = component.get("v.filteredProductList");
            
            action.setParams({ size : size,
                               prodList : prodList});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getFilteredRetailPriceCheckboxValues');
                        var lst = [];
                        resp.forEach(function(item)
                                     {
                                         var l = item.split('_')[1];
                                         var v = item.split('_')[0];
                                         lst.push({label:l, value:v});
                                         mapper[v] = l;
                                         
                                     });
                         component.set("v.retailPriceOptions", lst);
                        if(component.get("v.retailPriceOptions").length < size + 1){
                        	component.set("v.IsRetailPMore", false);
                    	}
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
        }
        
        
    },
    
    getMoreCompletionLevel : function(component, event, helper) {
        var size = component.get("v.completionLevelSize");
        size = size + 5;
        component.set("v.completionLevelSize", size);
        
        if(component.get("v.filteredProductList").length==0){
            var action = component.get('c.getCompletionLevelCheckboxValues');
            var mapper = component.get("v.mapper");
            
            action.setParams({ size : size});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getCompletionLevelCheckboxValues');
                        var lst = [];
                        resp.forEach(function(item)
                                     {
                                         lst.push({label:item, value:item});
                                         mapper[item] = item;
                                         
                                     });
                         component.set("v.completionLevelOptions", lst);
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
        } else {
            var action = component.get('c.getFilteredCompletionLevelCheckboxValues');
            var mapper = component.get("v.mapper");
            var prodList = component.get("v.filteredProductList");
            
            action.setParams({ size : size,
                               prodList : prodList});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getFilteredCompletionLevelCheckboxValues (Resp Length) '+ resp.length);
                        var lst = [];
                        resp.forEach(function(item)
                                     {
                                        var l = item.split('_')[1];
                                        var v = item.split('_')[0];
                                        lst.push({label:l, value:v});
                                        mapper[v] = l;
                                         
                                     });
                        component.set("v.completionLevelOptions", lst);
                        if(component.get("v.completionLevelOptions").length < size + 1){
                        	component.set("v.IsComLevelMore", false);
                    	}
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
        }
        
        
    },
    
    getMoreScale : function(component, event, helper) {
        var size = component.get("v.scaleSize");
        size = size + 5;
        component.set("v.scaleSize", size);
        
        if(component.get("v.filteredProductList").length==0){
            var action = component.get('c.getScaleCheckboxValues');
            var mapper = component.get("v.mapper");
            
            action.setParams({ size : size});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getScaleCheckboxValues');
                        var lst = [];
                        resp.forEach(function(item)
                                     {
                                         lst.push({label:item, value:item});
                                         mapper[item] = item;
                                         
                                     });
                        component.set("v.scaleOptions", lst);
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
        } else {
            var action = component.get('c.getFilteredScaleCheckboxValues');
            var mapper = component.get("v.mapper");
            var prodList = component.get("v.filteredProductList");
            
            action.setParams({ size : size,
                               prodList : prodList});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getFilteredScaleCheckboxValues (Resp Length) '+ resp.length);
                        var lst = [];
                        resp.forEach(function(item)
                                     {
                                         var l = item.split('_')[1];
                                         var v = item.split('_')[0];
                                         lst.push({label:l, value:v});
                                         mapper[v] = l;
                                         
                                     });
                        component.set("v.scaleOptions", lst);
                        if(component.get("v.scaleOptions").length < size + 1){
                        	component.set("v.IsScaleMore", false);
                    	}
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
        }
        
        
    },
    
    getMorePowerType : function(component, event, helper) {
        var size = component.get("v.powerTypeSize");
        size = size + 5;
        component.set("v.powerTypeSize", size);
        
        if(component.get("v.filteredProductList").length==0){
            var action = component.get('c.getPowerTypeCheckboxValues');
            var mapper = component.get("v.mapper");
            
            action.setParams({ size : size});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getPowerTypeCheckboxValues');
                        var lst = [];
                        resp.forEach(function(item)
                                     {
                                         lst.push({label:item, value:item});
                                         mapper[item] = item;
                                         
                                     });
                         component.set("v.powerTypeOptions", lst);
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
        } else {
            var action = component.get('c.getFilteredPowerTypeCheckboxValues');
            var mapper = component.get("v.mapper");
            var prodList = component.get("v.filteredProductList");
            
            action.setParams({ size : size,
                               prodList : prodList});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getFilteredPowerTypeCheckboxValues (Resp Length) '+ resp.length);
                        var lst = [];
                        resp.forEach(function(item)
                                     {
                                         var l = item.split('_')[1];
                                         var v = item.split('_')[0];
                                         lst.push({label:l, value:v});
                                         mapper[v] = l;
                                         
                                     });
                        component.set("v.powerTypeOptions", lst);
                        if(component.get("v.powerTypeOptions").length < size + 1){
                        	component.set("v.IsPoTypMore", false);
                    	}
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
        }
        
        
    },
    
    getMoreVehicleType : function(component, event, helper) {
        var size = component.get("v.vehicleTypeSize");
        size = size + 5;
        component.set("v.vehicleTypeSize", size);
        
        if(component.get("v.filteredProductList").length==0){
            var action = component.get('c.getVehicleTypeCheckboxValues');
            var mapper = component.get("v.mapper");
            
            action.setParams({ size : size});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getVehicleTypeCheckboxValues');
                        var lst = [];
                        resp.forEach(function(item)
                                     {
                                         lst.push({label:item, value:item});
                                         mapper[item] = item;
                                         
                                     });
                         component.set("v.vehicleTypeOptions", lst);
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
        } else {
            var action = component.get('c.getFilteredVehicleTypeCheckboxValues');
            var mapper = component.get("v.mapper");
            var prodList = component.get("v.filteredProductList");
            
            action.setParams({ size : size,
                               prodList : prodList});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp!=null && resp.length > 0){
                        console.log('SUCCESS: getFilteredVehicleTypeCheckboxValues (Resp Length) '+ resp.length);
                        var lst = [];
                        resp.forEach(function(item)
                                     {
                                         var l = item.split('_')[1];
                                         var v = item.split('_')[0];
                                         lst.push({label:l, value:v});
                                         mapper[v] = l;
                                         
                                     });
                        component.set("v.vehicleTypeOptions", lst);
                        if(component.get("v.vehicleTypeOptions").length < size + 1){
                        	component.set("v.IsVehTypMore", false);
                    	}
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
        }
        
        
    },
    
    handleChange:function (component, event, helper) {
       	var i = 0;
        var renderedList = [];
        //renderedList = component.get("v.renderedList");
        var renderedListString = JSON.stringify(component.get("v.renderedList"));
        if(component.get("v.IsCat")){
            //Selected Category Options Updated
            var category = component.find("categories").get("v.value");
           // var renderedList = [];
            category.forEach(function(item)
                        {
                            //if(renderedListString.indexOf(item) < 0){
                                var v = 'categories' + '_' + i + '_' + item + '_'; //Setting Value in this way to help in removing from rendered List in a single step
                                renderedList.push({label:component.get("v.mapper")[item], value:v});
                                i++
                            //}
                        });
        }
        
        //Selected Manufacturer Options Updated
        if(component.get("v.IsMan")){
            i = 0;
            var manufacturer = component.find("manufacturers").get("v.value");
            if(manufacturer != null){
                manufacturer.forEach(function(item)
                            {
                                var v = 'manufacturers' + '_' + i + '_' + item + '_'; //Setting Value in this way to help in removing from rendered List in a single step
                                renderedList.push({label:component.get("v.mapper")[item], value:v});
                                i++
                            });
            }
        }
        
        //Selected Retail Prices Bracket Options Updated
        if(component.get("v.IsRetailP")){
            i = 0;
            var retailPrices = component.find("retailPrices").get("v.value");
            if(retailPrices != null){
                retailPrices.forEach(function(item)
                            {
                                var v = 'retailPrices' + '_' + i + '_' + item + '_'; //Setting Value in this way to help in removing from rendered List in a single step
                                renderedList.push({label:component.get("v.mapper")[item], value:v});
                                i++
                            });
            }
        }
        
        //Selected Completion Level Options Updated
        if(component.get("v.IsComLevel")){
            i = 0;
            var completionLevel = component.find("completionLevel").get("v.value");
            if(completionLevel != null){
                completionLevel.forEach(function(item)
                            {
                                var v = 'completionLevel' + '_' + i + '_' + item + '_'; //Setting Value in this way to help in removing from rendered List in a single step
                                renderedList.push({label:component.get("v.mapper")[item], value:v});
                                i++
                            });
            }
        }
        
        //Selected Scale Options Updated
        if(component.get("v.IsScale")){
            i = 0;
            var scale = component.find("scale").get("v.value");
            if(scale != null){
                scale.forEach(function(item)
                            {
                                var v = 'scale' + '_' + i + '_' + item + '_'; //Setting Value in this way to help in removing from rendered List in a single step
                                renderedList.push({label:component.get("v.mapper")[item], value:v});
                                i++
                            });
            }
        }
        
        //Selected Skill Level Options Updated
        if(component.get("v.IsSkLevel")){
            i = 0;
            var skillLevel = component.find("skillLevel").get("v.value");
            if(skillLevel != null){
                skillLevel.forEach(function(item)
                            {
                                var v = 'skillLevel' + '_' + i + '_' + item + '_'; //Setting Value in this way to help in removing from rendered List in a single step
                                renderedList.push({label:component.get("v.mapper")[item], value:v});
                                i++
                            });
            }
        }
        //Selected Power Type Options Updated
        if(component.get("v.IsPoTyp")){
            i = 0;
            var powerType = component.find("powerType").get("v.value");
            if(powerType != null){
                powerType.forEach(function(item)
                            {
                                var v = 'powerType' + '_' + i + '_' + item + '_'; //Setting Value in this way to help in removing from rendered List in a single step
                                renderedList.push({label:component.get("v.mapper")[item], value:v});
                                i++
                            });
            }
        }
        //Selected Status Options Updated
        if(component.get("v.IsSt")){
            i = 0;
            var status = component.find("status").get("v.value");
            if(status != null){
                status.forEach(function(item)
                            {
                                var v = 'status' + '_' + i + '_' + item + '_'; //Setting Value in this way to help in removing from rendered List in a single step
                                renderedList.push({label:component.get("v.mapper")[item], value:v});
                                i++
                            });
            }
        }
        //Selected Vehicle Type Options Updated
        if(component.get("v.IsVehTyp")){
            i = 0;
            var vehicleType = component.find("vehicleType").get("v.value");
            if(vehicleType != null){
                vehicleType.forEach(function(item)
                            {
                                var v = 'vehicleType' + '_' + i + '_' + item + '_'; //Setting Value in this way to help in removing from rendered List in a single step
                                renderedList.push({label:component.get("v.mapper")[item], value:v});
                                i++
                            });
            }
        }
        /*var oldRenderedList = [];
        var renderedListString = JSON.stringify(renderedList);
        oldRenderedList = component.get("v.renderedList");
        for(i=0; i<oldRenderedList.length; i++){
            console(renderedListString.indexOf(oldRenderedList[0].value));
        }*/
        //console.log(JSON.stringify(component.get("v.renderedList")));
        component.set("v.renderedList", renderedList);

        var compEvent = component.getEvent("RunFilterEvent");                        
        compEvent.fire();
        /*
        var compEvent = component.getEvent("updateFilterValues");
        compEvent.setParams({
            "FilterValues" : component.get("v.renderedList") 
        });
        compEvent.fire();*/
    },
    
	filterAccordion : function(component, event, helper) {
        debugger
        $(document).ready(function () {
			$('.filter-items li .opener').on('click', function () {
				$(this).closest('li').toggleClass('active');
				$(this).closest('li').siblings('li').find('.filter-content').slideUp();
				$(this).closest('li').siblings('li').removeClass('active');
				$(this).siblings('.filter-content').slideToggle();
			});
		});
    }
})