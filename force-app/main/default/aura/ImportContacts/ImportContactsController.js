({
    doInit : function(component, event, helper) {
        //getUserInfo
        debugger;
        var action = component.get('c.getUserInfo');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                debugger;
                var resp  = response.getReturnValue();
                console.log(resp);
                if(resp.ContactId!=null){
                    var contactId= resp.ContactId;
                    console.log(contactId);
                    component.set("v.dealerContactId",contactId);
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
            } else{
                console.log('Failed with state: ' + state);
            }
        });
        
        //send action to be executed
        $A.enqueueAction(action);
        
        
        var a = component.get('c.getListOfOrders');
        $A.enqueueAction(a); 

        
        var value = '1';
        var iterationValues = component.get("v.iterationValues");
        iterationValues[0] = value;
        component.set("v.iterationValues",iterationValues);
    },
    scriptsLoaded : function(component, event, helper) {
        component.set("v.isLoaded", true);
        setTimeout(function(){
            window.print();
        }, 2000);
    },
    onChangeOrderType : function(component,event,helper){
      var orderType=  component.get('v.orderType');
        //alert(orderType);
        if(orderType=='CreateOrder'){
            //get csv file content:
            //helper.getCSVContent(component,event,helper);
            
            //create new order and add line items
            
            //helper.addProductsToNewOrder(component,event,helper);
            
            //create order
            //we can call addProductsToNewOrder from here:
            helper.addProductsToNewOrder(component,event,helper);
            
        }else if(orderType=='DraftOrders'){
             //get csv file content:
            //helper.getCSVContent(component,event,helper);
            component.set('v.showAddToDraftOrder',true);
            
        }else if(orderType=='DraftOrders-B'){
            //show draft order true:
            //helper.getCSVContentB(component,event,helper);
            //component.set("v.showDraftOrders",true);
            component.set("v.showDraftOrders",true);
            
        }
         else{
            component.set('v.showAddToDraftOrder',false);

        }
    },
    validatePDF: function(component, event, helper) {
         var dealerContID= component.get('v.dealerContactId');
        var action = component.get("c.validateFilePDF");
        action.setParams({ recordId : dealerContID});
        action.setCallback(this, function(result) {
            var content = document.createElement("a");
            content.href = "data:application/pdf;base64,"+result.getReturnValue();
            content.download = 'OrderLineImportResult.pdf';
            content.click();
        });
        $A.enqueueAction(action);
    },

    Validate:function (component, event, helper) {
        debugger;
        var dealerContID= component.get('v.dealerContactId');
        var action = component.get('c.validateFile');
        action.setParams({ recordId : dealerContID});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                debugger;
                var resp = response.getReturnValue();
                //alert(resp);
                //alert(resp);
                
                var OrderLines = [];
                var successLines= [];
                var success=0;
                var failed=0;
                
                //var conts = response.getReturnValue();
                for(var key in resp){
                    OrderLines.push({value:resp[key], key:key});
                    if(resp[key]=='Accepted'){success=success+1;successLines.push(key);}
                    else{failed=failed+1;}
                }
                console.log('success lines::'+successLines);
                if(successLines!=null){
                    component.set("v.SuccessLines", successLines);
                }
                component.set("v.OrderLineItemsResult", OrderLines);
                 component.set("v.showBool", true);
                
                component.set("v.FailedRecords",failed);
                component.set("v.SuccessRecords",success);
                component.set("v.TotalRecords", failed+success);
                //show modal"
                component.set("v.isModalOpen", true);
                
                //get csv content:
                helper.getCSVContent(component,event,helper);

                
                //set show order button true if there is atleast one success:
                //component.set("v.showOrderButton",true);

            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                }
            } else{
                console.log('Failed with state: ' + state);
            }
        });
        
        //send action to be executed
        $A.enqueueAction(action);
    },
    
    handleUploadFinished: function (cmp, event) {
        cmp.set('v.ValidateDisable',false);
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
        
        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
        

    },
    Add:function (component, event, helper) {
        
        
        var sku = component.find("sku");
        var quantity = component.find("quantity");
        var skuQuantityList = component.get("v.skuQuantityList");
        var Products = component.get("v.Products");
        debugger;
        var j = 0;
        for (var i=0; i<sku.length; i++) {
            Products[sku[i].get('v.value')] = quantity[i].getElements()[0].value;
            if(sku[i].get('v.value') != ''){
                if(quantity[i].getElements()[0].value == 0){
                    skuQuantityList[j] = sku[i].get('v.value') + '_' + 1;
                    sku[i].set('v.value','');
                } else{
                skuQuantityList[j] = sku[i].get('v.value') + '_' + quantity[i].getElements()[0].value;
                    sku[i].set('v.value','');
                    quantity[i].getElements()[0].value = 0;
                }
                j++;
                console.log(skuQuantityList[i]);
            }
            //console.log(quantity[i].get('v.value'));
        }
        
        if(skuQuantityList.length > 0){    
            component.set("v.iterationValues",{});
            component.set("v.showAddToDraftOrder",true);
        } else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "Enter Product Code and Quantity to Add to Draft Orders"
            });
            toastEvent.fire();
        }
    },
    
    newInputs:function (component, event, helper) {
        /*var sku = component.find("sku");
        var allowAddRows = true
        for (var i=0; i<sku.length; i++) {
            if(sku[i].get('v.value') == ''){
                allowAddRows = false;
                break;
            }
        }
        if(allowAddRows) {*/
            var value = '1';
            var iterationValues = component.get("v.iterationValues");
            iterationValues.push(value);            
            component.set("v.iterationValues",iterationValues);
      /*  } else {
            	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": "Add Product Code in all the current provided input"
                });
                toastEvent.fire();
        }*/
    },
    getListOfOrders : function(component, event, helper) {
        var action = component.get('c.getAllOrders');
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if (resp != null && resp.length >= 0) {
                    console.log('SUCCESS: getAllOrders');
                    //console.log(JSON.parse(resp.JSON));
                    component.set("v.orderList", resp);
                    console.log(resp[0]);
                    /*var a = component.get("v.orderList");
                    console.log(a.length);
                    a.push(a[0]);
                    component.set("v.orderList", a);
                    var b = component.get("v.orderList");
                    console.log(b.length);*/
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
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        //delete file
        debugger;
        helper.deleteContentDocument(component,event,helper);
        
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
        component.set("v.showBool",false);
        component.set("v.ValidateDisable",true);
    },
    closeCompleteModal: function(component,event,helper){
      	component.set("v.showImportModalComplete",false);  
    },
    proceed: function(component, event, helper) {
        //delete file
        helper.deleteContentDocument(component,event,helper);
        
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.set("v.isModalOpen", false);
        component.set("v.ValidateDisable",true);
        
        var successRec = component.get("v.SuccessRecords");
        if(successRec>0){
            component.set("v.showAddToDraftOrder",true);
            //business design can be enabled by uncommenting below line.
            //component.set("v.showOrderButton",true);
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "You cannot proceed further, because no orderline items were found in the system."
            });
            toastEvent.fire();
        }
        
    },
    
    checkValidity:function (component, event, helper) {
        debugger;
        var sku = event.getSource().get('v.name');
        var skuValue = '';
        var skuinstance = null
        var skuList = component.find("sku");
        skuList.forEach( skuElement=> {
            if(skuElement.get('v.name') == sku){
            skuValue= skuElement.get('v.value'); 
            skuinstance = skuElement;
        }});
        var action = component.get('c.CheckSKUValidity');
        action.setParams({ sku : skuValue});
            
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp){
                    console.log("SUCCESS: Valid Product Code");
                } else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Entered Wrong Product Code"
                    });
                    toastEvent.fire();
                    skuinstance.set('v.value', '');
                    component.set("v.showAddToDraftOrder",false);
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
            } else{
                console.log('Failed with state: ' + state);
            }
        });
        
        //send action to be executed
        $A.enqueueAction(action);
    },
       onChange : function(component,event,helper){ 
        debugger
        
        var intVal= parseInt(event.currentTarget.value);
        
        if(isNaN(intVal)){
            intVal=''
        }
        
        if(intVal<0)
        {
            intVal*=-1
            event.currentTarget.value = intVal;
        }
       
        
        
      
    }, 
  
    increment:function (component, event, helper) {
        debugger;
        var buttonName = event.getSource().get('v.name');
        var row = buttonName[1];
        var column = buttonName[0];
        
        var quantity = component.find("quantity");
        quantity.forEach( qty=> {
            if(qty.getElements()[0].name == buttonName){
            var intVal= parseInt(qty.getElements()[0].value)
            if(intVal <0)
            {
            	intVal=0
      		}
            if(isNaN(intVal)){
            	intVal=0
       		}
            qty.getElements()[0].value = intVal + 1;
            
        }
                         });
        
        
    },
    decrement:function (component, event, helper) {
        var buttonName = event.getSource().get('v.name');
        var row = buttonName[1];
        var column = buttonName[0];
        
        var quantity = component.find("quantity");
        quantity.forEach( qty=> {
            if(qty.getElements()[0].name == buttonName){
            var intVal= parseInt(qty.getElements()[0].value)
            if(isNaN(intVal)){
            	intVal=0
        	}
        
            if(intVal-1 <0)
            {
                intVal=1
            }
        	qty.getElements()[0].value = intVal - 1;
            
        }
                         });
        
    },
        addOrderLinesToDraftOrder: function(component,event,helper){
            debugger;
            //var checkbox = event.getSource().get("v.value");
            //console.log('checkbox:'+checkbox);
            var orderId = event.getSource().get("v.text"); 
            //alert(a);
           	helper.Add(component,event,helper,orderId);
            
        },
        addOrderLinesToDraftOrder1: function(component,event,helper){
            debugger;
            var currentTarget = event.currentTarget;
            var orderId = currentTarget.getAttribute("data-orderId");
            var text = currentTarget.text; 
            //alert(a);
           	helper.Add(component,event,helper,orderId);
            
        },
            helpDocument: function(component,event,helper){
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "https://horizonhobby--b2bdev.my.salesforce.com/sfc/p/6t0000004YsY/a/6t0000004Rd9/rp.DnHVFVZ8CFADCyvJL7uswKz.CVrbZDHo8cS9.KKQ"
                });
                urlEvent.fire();
                
            }    
        
})