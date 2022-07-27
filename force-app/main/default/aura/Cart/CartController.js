({
    init : function(component, event, helper) {
       
        component.set('v.columns', [
            //    {label: 'imageLink', fieldName: 'PrimaryImageLink', type: 'text'},
            
            {label: 'Item', fieldName: 'linkName', type: 'url',  typeAttributes: {label: { fieldName: 'ProductName' }, target: '_blank', required: true }},
            {
                label: 'QTY', fieldName: 'Quantity', type: 'number', editable: true,    
                
            },
            {label: 'Description', fieldName: 'Description', type: 'text'},
            
            {label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency', typeAttributes: { currencyCode: 'USD'},  typeAttributes: { required: true }, } ,
            {label: 'Total', fieldName: 'TotalPrice', type: 'currency', typeAttributes: { currencyCode: 'USD'}, typeAttributes: { required: true} },
            {label: 'BO', fieldName: 'Avail__c', type: 'text'},
            
            {label: 'Note', fieldName: 'Rank__c', type: 'text'}
            
            
            
            
        ]);    
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        debugger;
        var OrderID = helper.getUrlParameter(component,'oid');
        
        component.set('v.orderId',OrderID);
        
        var getOrderDetail = component.get('c.getOrderLineItemsDetails');
        getOrderDetail.setParams({ orderID : OrderID,userId :userId});
        
        getOrderDetail.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                debugger
                var data =JSON.parse(response.getReturnValue());
                component.set('v.orderData',data)
                
                var statusDiv = component.find('status')
                
                
                if(data.Name == '' || data.Name == null){
                    data.Name = 'My Order';
                }
            }
        });
        
        $A.enqueueAction(getOrderDetail);
        
        var action2 = component.get('c.getOrders');
        action2.setCallback(this, function(response){
            console.log('order2');
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('Success: getOrders');
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
        
        action2 = component.get('c.getOrderLineItems');
        action2.setParams({ orderID : OrderID});
        
        action2.setCallback(this, function(response){
            console.log('getOrderLineItems');
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('Success');
                console.log(JSON.parse(resp));
                if(resp!=null && resp.length > 0){
                    
                    // for not updating table and selected value of alert Tab when data is change
                    var oldVal = ''
                    if(component.get("v.data").length >0 ){
                        oldVal =   component.get("v.data")
                        //component.set("v.data", oldVal);
                    }
                    else{
                        component.set("v.data", JSON.parse(resp));
                    }
                    component.set("v.copyOfData", JSON.parse(resp));
                    
                    
                    var alertDetails = component.get('c.orderLineItemsGroupByAlerts');
                    alertDetails.setParams({ orderID : OrderID});
                    
                    alertDetails.setCallback(this, function(response){
                        var state = response.getState();
                        if(state === "SUCCESS") {
                            
                            debugger
                            var data =JSON.parse(response.getReturnValue());
                            var noData = true;
                           
                            var locale = $A.get("$Locale.language");
                            
                            
                            var trns = component.get('v.Translations')     
                            
                            
                            data.forEach(function(item){
                                
                                if(locale != 'en'){
                                    item.alertName = trns[0][item.alertName]
                                }
                                if(item.items.length >0){
                                    noData = false; 
                                    
                                }
                            },this);
                        
                            if (noData == true){
                                data = [] 
                            }
                            component.set('v.AlertGroupData',data)
                            
                            var statusDiv = component.find('status')
                            
                            
                            if(data.Name == '' || data.Name == null){
                                data.Name = 'My Order';
                            } 
                            
                            
                            
                            $(document).ready(function () { 
                                
                                $(document).on('click', function(event) {
                                    if(event.target.className != 'saved-opener active')
                                        $('.saved-lists .dropdown').hide();
                                    $('.saved-lists .saved-opener').toggleClass('active');
                                    
                                });
                                $('.saved-lists .saved-opener').on('click', function () {
                                    
                                    $(this).toggleClass('active');
                                    $(this).siblings('.dropdown').slideToggle();
                                    
                                });
                                //accordion script
                                $(".alerts-accordion .opener").click(function(){
                                    
                                    debugger
                                    $(this).toggleClass('active');
                                    $(this).siblings(".line-items-content").slideToggle();
                                    $(this).closest("li").siblings("li").find(".line-items-content").slideUp();
                                    $(this).closest("li").siblings("li").find(".opener").removeClass('active');
                                }); 
                                $('.tabset a').on('click', function(event){
                                    event.preventDefault();
                                    
                                    event.stopImmediatePropagation();
                                    var isActive = false
                                    if($(this).parent()[0].className.includes('active')){
                                        isActive = true
                                    }
                                    $(this.closest('ul').children).removeClass('active')
                                    if(isActive){
                                        $(this).parent().addClass('active');
                                    }
                                    //$(this).closest('li').siblings('li').removeClass('active');
                                    $(this).parent().toggleClass('active');
                                    
                                    $( document.getElementById($(this).attr('href'))).toggleClass('tab-active').siblings().removeClass('tab-active');
                                });
                                
                            });
                            
                        }
                    });
                    
                    $A.enqueueAction(alertDetails);
                    
                    
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
        
        /*               $(document).ready(function () { 
                                
                               $(document).on('click', function() {
                                
                                    $('.saved-lists .dropdown').hide();
                                
                                });
                                
                                $('.saved-lists .dropdown').hide();
                                
                                $('.saved-lists .saved-opener').on('click', function (event) {
                                    //$(this).toggleClass('active');
                                    //$(this).siblings('.dropdown').slideToggle();
									$('.saved-lists .dropdown').slideDown();
                                    event.stopPropagation();

                                });

                                /*
                                $('.saved-lists .saved-opener').on('click', function () {
                                    
                                    $(this).toggleClass('active');
                                    $(this).siblings('.dropdown').slideToggle();
                                });
                                //accordion script
                                $(".alerts-accordion .opener").click(function(){
                                    
                                    debugger
                                    $(this).toggleClass('active');
                                    $(this).siblings(".line-items-content").slideToggle();
                                    $(this).closest("li").siblings("li").find(".line-items-content").slideUp();
                                    $(this).closest("li").siblings("li").find(".opener").removeClass('active');
                                }); 
                                $('.tabset a').on('click', function(event){
                                       event.preventDefault();
                                 
                                    event.stopImmediatePropagation();
                                    var isActive = false
                                    if($(this).parent()[0].className.includes('active')){
                                        isActive = true
                                    }
                                    $(this.closest('ul').children).removeClass('active')
                                    if(isActive){
                                        $(this).parent().addClass('active');
                                    }
                                    //$(this).closest('li').siblings('li').removeClass('active');
                                    $(this).parent().toggleClass('active');
                                   
                                    $( document.getElementById($(this).attr('href'))).toggleClass('tab-active').siblings().removeClass('tab-active');
                                });
                                
                                
                            });        
        */
        // language Translation
        var locale = $A.get("$Locale.language");
        
        if(locale != 'en'){
            helper.getTranslation(component, event, helper)
            
        }
        
    },
    
    MoveToDraftOrderAll : function(component, event, helper) {
        var selectedValues = component.get('v.SelectedValues');
        if(selectedValues.length > 0){
            var isCheckAll = component.get('v.isCheckAll');
            if(isCheckAll){
                component.set("v.callName", 'ExistingOrder');
                component.set("v.showDeleteAlert", true);
            } else {
                var a = component.get('c.addToCartHandler'); 
                $A.enqueueAction(a);
            }
        }
    },
    
    addToCartHandler : function (component,event,helper){
        var action = component.get('c.generateListForProducts');
        action.setParams({ products : component.get('v.SelectedValues')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var res = response.getReturnValue();
                if(res!=null && res.length>0){
                    console.log('SUCCESS: generateListForProducts');
                    var prodList = res;
                    component.set("v.skuQuantityList", prodList);
                    component.set("v.onlyDraftOrder",true);
                    component.set("v.onlyNewOrder",false);
                    component.set("v.showAddToDraftOrder",true);                    
                    
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
    
    MoveToNewOrderAll : function(component, event, helper) {
        var selectedValues = component.get('v.SelectedValues');
        if(selectedValues.length > 0){
            var isCheckAll = component.get('v.isCheckAll');
            if(isCheckAll){
                component.set("v.callName", 'NewOrder');
                component.set("v.showDeleteAlert", true);
            } else {
                var a = component.get('c.MoveToNewOrder'); 
                $A.enqueueAction(a);
            }
        }
    },
    
    MoveToNewOrder : function(component, event, helper) {
        /*var action = component.get('c.generateListForProducts');
        var orderId = component.get('v.orderId');
        var selectedValues = component.get('v.SelectedValues');
        action.setParams({ products : component.get('v.SelectedValues')});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('Success: generateListForProducts');
                if(resp!=null && resp.length>0){
                    var action2 = component.get('c.AddToNewOrder');
                    action2.setParams({ skuQuantityListString : JSON.stringify(resp),
                                       orderID : orderId,
                                       products : selectedValues});
                    
                    action2.setCallback(this, function(response){
                        var state = response.getState();
                        if(state === "SUCCESS") {
                            var res = response.getReturnValue();
                            if(res!=null){
                                console.log('SUCCESS: AddToNewOrder');
                                var link = "/horizonhobby/s/cart?oid=" + res;
                                window.location.href = link;
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
                } else{
                    
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
        });*/
        
        var action = component.get('c.generateListForProducts');
        console.log(component.get('v.SelectedValues'));
        action.setParams({ products : component.get('v.SelectedValues')});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('test3');
            if(state === "SUCCESS") {
                var res = response.getReturnValue();
                if(res!=null && res.length>0){
                    console.log('SUCCESS: generateListForProducts');
                    var prodList = res;
                    component.set("v.skuQuantityList", prodList);
                    component.set("v.onlyNewOrder",true);
                    component.set("v.onlyDraftOrder",false);
                    component.set("v.showAddToDraftOrder",true);
                    
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
    
    MovingOrderLineItem : function(component, event) {
        console.log('123');
        debugger;
        var isNew = event.getParam("isNew"); 
        if(isNew){
            var a = component.get('c.MoveToNewOrder'); 
            $A.enqueueAction(a);
        } else {
            var a = component.get('c.addToCartHandler'); 
            $A.enqueueAction(a);
        }
    },
    
    //Delete all the selected line items
    Delete : function(component, event, helper) {
        var action = component.get('c.deleteOrderLineItems');
        var orderId = component.get('v.orderId');
        var selectedValues = component.get('v.SelectedValues');
        var deleteAll = component.get('v.isCheckAll');
        
        action.setParams({ orderID : orderId,
                          products : selectedValues,
                          deleteAll: deleteAll});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('Success: deleteOrderLineItems');
                if(resp!=null && resp.includes("Error")){
                    console.log(resp);
                } else{
                    if(deleteAll){
                        location.assign("/horizonhobby/s/order-summary");
                    } else{
                        location.reload();
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
    
    deleteLineItems : function(component, event, helper) {
        var selectedValues = component.get('v.SelectedValues');
        if(selectedValues.length > 0){
            var isCheckAll = component.get('v.isCheckAll');
            if(isCheckAll){
                component.set("v.deleteAll", true);
            }
            component.set("v.callName", 'Delete');
            component.set("v.showDeleteAlert", true);
        }
    },
    
    Edit : function(component, event, helper) {
        component.set("v.notEdit", false);
    },
    
    Save : function(component, event, helper) {
        debugger;
        var name = component.find("Name").get("v.value");
        
        var action2 = component.get('c.UpdateName');
        action2.setParams({ Name : name,
                           oid : OrderID});
        action2.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('Success: UpdateName');
                data.Name = name;
                component.set("v.notEdit", true);
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
    
    savedFilterCollapse : function(component, event, helper) {
        debugger
        
        var OrderID = helper.getUrlParameter(component,'oid');
        
        var alertDetails = component.get('c.orderLineItemsGroupByAlerts');
        alertDetails.setParams({ orderID : OrderID});
        
        alertDetails.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                debugger
                var data =JSON.parse(response.getReturnValue());
                var noData = true;
                  var locale = $A.get("$Locale.language");
                
                
                
                var trns = cmp.get('v.Translations')     
                
                data.forEach(function(item)
                             {
                                 if(locale != 'en'){
                                     item.alertName = trns[item.alertName]
                                 }
                                 if(item.items.length >0){
                                     noData = false; 
                                     
                                 }
                             },this);
                
                if (noData == false){
                    data = [] 
                }
                component.set('v.AlertGroupData',data)
                
                var statusDiv = component.find('status')
                
                if(data.Name == '' || data.Name == null){
                    data.Name = 'My Order';
                }
                
                $(document).ready(function () {
                    $('.saved-lists .saved-opener').on('click', function () {
                        $(this).toggleClass('active');
                        $(this).siblings('.dropdown').slideToggle();
                    });
                    //accordion script
                    $(".alerts-accordion .opener").click(function(){
                        debugger
                        $(this).toggleClass('active');
                        $(this).siblings(".line-items-content").slideToggle();
                        $(this).closest("li").siblings("li").find(".line-items-content").slideUp();
                        $(this).closest("li").siblings("li").find(".opener").removeClass('active');
                    });
                    // order tabs
                    $('.tabset a').on('click', function(event){
                        event.preventDefault();
                        $(this).closest('li').siblings('li').removeClass('active');
                        $(this).parent().toggleClass('active');
                        $($(this).attr('href')).toggleClass('tab-active').siblings().removeClass('tab-active');
                    });
                    
                });
            }
        });
        
        $A.enqueueAction(alertDetails);
        
        
    },
    
    headerClick:function (component, event, helper){
        debugger
        
        var id = event.currentTarget.getAttribute('id')
        console.log(id) 
        component.find("sort").getElements()[0].value = id.split('|')[0];
        var selected = component.find("sort").getElements()[0].value;  
        if(selected == 'Rank__c'){
            return
        }
        if(event.currentTarget.innerHTML.includes("▼")){
            event.currentTarget.innerHTML = event.currentTarget.innerHTML.slice(0,-2) + " ▲"
        }
        else{
            event.currentTarget.innerHTML = event.currentTarget.innerHTML.slice(0,-2) + " ▼"
            
        }
        helper.onSortChange(component, event, helper, id.split('|')[1])
        
    },
    
    onCheckAll:function (component, event, helper){
        debugger
        component.set('v.isParentCheckAll',event.getSource().get('v.checked'))
        component.set('v.isCheckAll',event.getSource().get('v.checked'))
        
    },
    
    handleCheckValueChange:function (component, event, helper){
        debugger
        //  component.find('parentSelectAll').set('v.checked',component.get('v.isCheckAll'))
        
    },
    
    updateLineItem:function (component, event, helper){
        var data = component.get('v.data');
        
        var action2 = component.get('c.UpdateLineItem');
        action2.setParams({ 
            lines : JSON.stringify(data)});
        action2.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Updated Successfully!",
                    "mode": "pester",
                    "type":"success",
                    "duration": 2000,
                    "message": "Line Item(s) updated Successfully..."
                });
                toastEvent.fire();
                component.set('v.isLineUpdated',false);
                
                var rerender = component.get('c.init');
                $A.enqueueAction(rerender);
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
    
    updateOrder:function (component, event, helper){
        debugger
        var orderid = component.get('v.orderId')
        // var orderData = component.get('v.orderData')
        
        var action2 = component.get('c.updateOrderInfo');
        action2.setParams({ 
            oid :orderid,
            poNumber:component.find('PONumber').getElements()[0].value,
            description:component.find('Description').getElements()[0].value,
            endDate:component.find('EndDate').getElements()[0].value,
            
        });
        action2.setCallback(this, function(response){
            
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('Success');
                
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
    
    showMoreLines:function (component, event, helper){
        debugger
        if(event.currentTarget.innerText == 'Show More'){
            event.currentTarget.previousSibling.classList.add('ShowAll')
            event.currentTarget.classList.add('show-less')
            event.currentTarget.innerText = 'Show Less'
        }
        else
        {
            event.currentTarget.classList.remove('show-less')
            event.currentTarget.previousSibling.classList.remove('ShowAll')
            event.currentTarget.innerText = 'Show More'
            
        }
        
        
    },
    
    print:function (component, event, helper){
        var htmlText = '<html>';
        var p = getComputedStyle(component.find("toPrint").getElements()[0])
        // var css = '.slds-table{'
        debugger
        // css+='}th, td {  border-bottom: 1px solid #ddd;}.slds-text-title_bold{ font-size:8pt; float:center}';
        // var css ='.slds-text-title_bold{ font-weight: bold; font-size:8pt } body{ font-size:8pt }  th, td { overflow: hidden;padding:0px;border-bottom: 1px solid #ddd; padding-left: 3px; margin: 0px; width: auto; white-space: nowrap; max-width: 110px;  }  .slds-p-around_medium h1 { padding: 0px; width:50%; text-align:center } .slds-table{ width : 52%;font-size: 9pt; }'
        var css ='.cart-page { padding:15px; background: #fff; } .cart-page h2 { font-size: 28px; line-height: 32px; font-weight: bold; margin: 0 0 20px; }  .cart-details { display: flex; align-items: flex-start; }  .cart-details .cart-head { display: flex; align-items: center; margin: 0 0 10px; }  .cart-details .items-details { width: 75%; padding-right: 20px; }  .summary-details { background: #e1e1e1; padding: 15px; text-align: center; width: 25%; }  .shipping-progress { margin: 0 0 25px; }  .shipping-progress .shipping-title { display: block; margin: 0 0 5px; font-size: 12px; font-weight: normal; }  .shipping-progress .shipping-title .shipping-status { color: #003567; font-weight: bold; text-transform: uppercase; }  .summary-details .title{ font-size: 20px; line-height: 22px; margin: 0 0 15px; display: block; }  .order-summary-list { list-style: none; padding: 0; margin: 0 0 15px; }  .order-summary-list li { display: flex; margin: 0 0 8px; }  .order-summary-list li .sub-title { flex-grow: 1; padding: 0 5px 0 0; text-align: left; }  .order-summary-list li.totals { font-weight: bold; }  .summary-details .btn-default{ display: block; text-decoration: none; }  .progress-bar { width: 100%; height: 5px; position: relative; background: #fff; }  .progress-bar .status { position: relative; height: 5px; left: 0; top: 0; bottom: 0; background: #003567; } /*line item*/  .line-item { display: flex; flex-flow: row wrap; margin: 0 -5px; }  .line-item .col { width: 33.333%; padding: 0 5px; }  .line-item dl { overflow: hidden; }  .line-item dl dt { font-weight: bold; width: 70%; float: left; margin: 0 0 5px; }  .line-item dl dd { overflow: hidden; margin: 0 0 5px; }  .line-item dl sup { margin: -2px 0 0; vertical-align: top; display: inline-block; font-size: 75%; }  .line-item .form-control { width: 100%; outline: none; resize: none; height: 38px; color: #000000; border-radius: 3px; border: 1px solid #e1e1e1; padding: 10px; margin: 0 0 15px; }  .line-item textarea.form-control { height: 160px; }  .saved-lists { background: #fff; font-size: 12px; line-height: 14px; font-weight: 500; position: relative; }  .saved-lists .saved-opener { padding: 10px; display: block; color: #003567; text-decoration: none; margin: 0 0 -3px; }  .saved-lists .saved-opener span:before { color: #003567; display: block; margin: 0 0 0 2px; transition: all 0.3s ease-in-out; }  .saved-lists .saved-opener.active span:before { transform: rotate(-180deg); }  .saved-lists .dropdown { display: none; padding: 0 10px; position: absolute; left: -1px; width: 420px; top: calc(100% - 1px); border: 1px solid #7d7d7d; background: #fff; z-index: 2; max-height: 400px; overflow: auto; }  .dropdown .slds-table_bordered { border: 0; color: #000; font-size: 13px; }  .dropdown .slds-cell-fixed { position: static; }  .dropdown .slds-table thead th { color: #000; padding: 0; border-bottom: 1px solid #e1e1e1; }  .dropdown .slds-truncate a{ color: #000; }  .dropdown .slds-table thead th .slds-cell-fixed { padding: 15px 0; }  .dropdown .slds-table_bordered tbody td { padding: 15px 0; border: 0; min-height: 61px; }  .dropdown .slds-table_bordered tbody td:last-child { text-align: right; }  .dropdown .slds-table_bordered tbody tr:hover td { box-shadow: none; background: none; }  .dropdown .slds-table_bordered tbody tr + tr td { border-top: 1px solid #dcdcdc; }  .edit-item { position: relative; margin: 2px 0 0; }  .edit-item .edit-dropdown { padding: 10px; background: #fff; position: absolute; left: 8px; top: 100%; width: 300px; display: flex; margin-top: 2px; z-index: 1; border: 1px solid #1e1e1e; }  .edit-item .edit-dropdown .slds-form-element__control { padding: 0 10px 0 0; }  .edit-item .edit-dropdown .slds-input { height: 40px; }  .edit-item .edit-dropdown .btn-default { min-width: 90px; text-align: center; border-radius: 3px; }  .edit-item .edit-dropdown .slds-form-element__label:empty { display: none; }  .greyOut{ pointer-events: none; background: #CCC; color: #333; border: 1px solid #666 } .slds-hidden { display: none; }  .slds-is-relative { z-index:1; } .catalog-results { display: flex; }  .search-results { padding: 0 0 0 15px; }  .prev,  .next { width: 31px; height: 33px; border: 0; background: #000; color: #fff; border-radius: 0; position: relative; padding:0; font-size: 0; line-height: 0; }  .prev:before,  .next:after { content: ""; font-family: "Font Awesome 5 Pro"; color: #fff; position: absolute; font-size: 20px; line-height: 32px; }  .next:after { content: "ff54"; }  .items-count { text-align: right; padding: 0 10px; }  .paging a{ color: #000; }  .paging b a { margin: 0 3px; text-decoration: underline; }  .custom-select { display: inline-block; vertical-align: middle; width: 98px; }  .custom-select select { width: 100%; min-width: 100%; padding: 5px 15px 5px 5px; }  .custom-select.num { width: 60px; margin: 0 0 0 8px; }  .custom-checkbox { display: inline-block; vertical-align: middle; margin:0 15px 0 0; }  .checkbox-row { display: flex; }  .select-row { display: flex; justify-content: flex-end; }  .print-list { list-style: none; margin:0; padding:0; display: flex; }  .print-list li + li:before { content:"|"; margin: 0 5px; }  .export-options { display: flex; justify-content: center; font-size: 12px; font-weight: 500; } .slds-is-relative { margin: 0 0 15px; }  .export-options .sub-title { padding: 0 3px 0 15px; }  .export-options a{ color: #000; text-decoration: underline; } .items-head td { padding: 15px 0; }  .slds-table { border: 1px solid #e1e1e1; }  .slds-table thead th { vertical-align: top; }  .slds-table thead th { width: 35px; }  .slds-table thead th:first-child { max-width: 10px; }  .slds-table thead th:nth-child(2) { max-width: 30px; }  .slds-table thead th:nth-child(8)  { width: 130px; }  .slds-table tbody td,  .slds-table thead th { color: #000; font-size: 12px; line-height: 18px; font-weight: 700; padding: 5px 5px 5px 0; border-top: 0; }  .slds-table thead th { padding: 15px 10px; border-bottom: 1px solid #e1e1e1; }  .slds-table thead th .slds-th__action { padding: 0; height: auto; /* white-space: normal;*/ }  .slds-table tbody td { font-weight: 400; padding: 10px 5px; }  .slds-table tbody td.slds-cell-edit { padding-left: 10px; }  .slds-table tbody tr:hover td { background: #fff; box-shadow: none !important; }  .slds-table tbody tr + tr td { border-top: 1px solid #e1e1e1; }  .slds-cell-edit .slds-popover { width: 70px; box-shadow: none; border-radius: 0; position: static !important; border: 0; }  .slds-cell-edit .slds-popover input { text-align: center; border-radius: 0; border-color: #e1e1e1; outline: none; }  .slds-popover_edit .slds-popover__body { padding: 0; }  .slds-popover .slds-form-element__control button { border: 0; color: #000; outline: none; }  .slds-popover .slds-form-element__control button:focus{ box-shadow: none; }  .slds-popover .slds-form-element__control .slds-input__button_decrement { left: 5px; }  .slds-popover .slds-form-element__control .slds-input__button_increment { right: 5px; }  .search-selects-footer { padding: 5px; display: flex; align-items: center; justify-content: center; background: linear-gradient(90deg, rgba(188,186,186,1) 0%, rgba(225,225,225,1) 100%); }  .search-selects-footer .btn-default { border-radius: 0; margin:0 5px; font-size: 12px; }  .search-selects-footer .slds-button_neutral:hover { color: #fff; background: #003567; }  .search-selects-footer .btn-default.clear { background: #7d7d7d; }  .items-summary { list-style: none; padding: 0; margin: 0; display: flex; align-items: center; }  .items-summary li { padding: 0 10px; position: relative; }  .items-summary li + li:before { content: "|"; position: absolute; left: 0; top: 0; }  .filters-selected { padding: 8px; margin: 20px 0; display: inline-block; vertical-align: top; border: 1px solid #7d7d7d; }  .filters-selected .title { display: inline-block; vertical-align: top; padding: 0 8px; background: #fff; margin: -20px 0 20px; }  .filters-selected .links-area { display: inline-flex; vertical-align: middle; align-items: center; padding: 0 0 0 20px; }  .filters-selected .links-area .btn-default { border-radius: 0; position:relative; padding: 7px 15px; }  .filters-selected .links-area .btn-default:before { content: ""; font-family: "Font Awesome 5 Pro"; margin: -2px 6px 0 0; display: inline-block; vertical-align: middle; }  .filters-selected .links-area .clear-all { color: #7d7d7d; font-weight: 500; margin: 0 0 0 15px; text-decoration: underline; }  .filters-selected .filters-content { display: flex; align-items: flex-start; margin: -15px 0 0; }  .tags-list { list-style: none; padding: 7px 0 0 0; margin: 0 -8px; display: inline-flex; flex-flow: row wrap; font-weight: 500; flex-grow: 1; flex-basis: 0; }  .tags-list li { padding: 4px 8px; }  .tags-list li a { color: #000; margin: 0 0 0 5px; } .print-modal .slds-modal__container{ max-width: 595px; min-width: inherit; width: auto; padding: 10px; } .print-modal .slds-modal__header { text-align: left; border-bottom: 1px solid #f4f4f4; padding: 0 0 10px; margin: 0 0 20px; } .print-modal .slds-modal__close { position: static; float: right; margin: -5px 0 0; } .print-modal .slds-modal__close .slds-button_icon-inverse { color: #000; width: 20px; height: 20px; } .print-modal .slds-theme_default { padding: 15px; } .print-modal .slds-modal__title { color: #333; font-size: 18px; line-height: 22px; font-weight: 700; } .print-modal .btn-default { border-radius: 0; } .print-modal .slds-modal__content:last-child { box-shadow: none; padding: 0; border-radius: 0; }  .order-info { display: flex; align-items: center; flex-flow: row wrap; flex-grow: 1; }  .order-info .title { color: #003567; font-size: 20px; line-height: 22px; }  .order-info .item-numbers { font-size: 20px; line-height: 22px; padding: 0 5px; }  .order-info .edit { color: #003567; margin: 0 8px; }  .cart-import-export { display: flex; }  .cart-import-export li + li:before { content: "|"; margin: 0 8px; color: #000; }  .cart-import-export li a { color: #000; }' 
        var css2 = '/*order alerts*/  .order-alerts { padding: 15px; background: #fefcf3; border-top: 1px solid #e1e1e1; }  .order-alerts h2 { display: inline-block; vertical-align: top; margin: 0 0 20px; }  .order-alerts h2 span { margin: 0 10px; text-decoration: underline; }  .order-alerts h2:after,  .order-alerts h2:before { content: "!"; color: #e9cd0e; font-weight: 900; }  .alerts-accordion { list-style: none; margin: 0; padding: 0; letter-spacing: -0.32em; }  .alerts-accordion > li { margin: 0 5px 10px; background: #fff; width: calc(50% - 10px); border: 1px solid #e1e1e1; display: inline-block; vertical-align: top; letter-spacing: 0; }  .alerts-accordion .opener { color: #000; display: flex; align-items: center; padding: 10px 40px 10px 10px; position: relative; text-decoration: none; }  .alerts-accordion .opener:after { content: "+"; position: absolute; right: 10px; top: 15px; font-size: 25px; }  .alerts-accordion .opener.active:after { content: "--"; top: 13px; right: 13px; letter-spacing: -2px; }  .alerts-accordion .opener .icon { width: 26px; }  .alerts-accordion .opener .title { padding: 0 0 0 8px; }  .alerts-accordion .opener .title:after { content: "|"; margin: 0 5px; }  .alerts-accordion .line-items-content { display: none; padding: 10px; font-size: 10px; line-height: 14px; }  .alerts-accordion .items-list { list-style: none; margin: 0 0 5px; padding: 0; }  .alerts-accordion ul.items-list li:nth-of-type(1n+4) {display: none;}  .alerts-accordion ul.items-list.ShowAll li:nth-of-type(1n+4) {display: block;}  .alerts-accordion .show-more { color: #000; font-weight: bold; text-decoration: underline; }  .alerts-accordion .show-more:before { content: "+"; margin: 0 3px 0 0; }  .alerts-accordion .show-less:before { content: "-"; margin: 0 3px 0 0; }  .order-tabs { padding: 8px 10px; background: #fefcf3; border: 1px solid #e1e1e1; }  .tabset { list-style: none; padding: 0; margin: 0; display: inline-flex; border-bottom: 1px solid #e1e1e1; }  .tabset li { margin: 0 5px 0 0; }  .tabset li:last-child { margin: 0; }  .tabset li a { width: 26px; display: block; text-decoration: none; padding: 0 0 3px; margin: 0 0 -1px; border-bottom: 2px solid transparent; }  .tabset li.active a { border-bottom-color: #000; }  .tabset li img { width: 100%; height: auto; }  .order-tabs .tab-pane { display: none; }  .order-tabs .tab-pane.tab-active { display: block; }  .order-tabs .inner-content { display: flex; padding: 5px 0; }  .order-tabs .title:before { content: "!"; color: #e9cd0e; font-weight: 900; margin: 0 5px 0 0; }  .order-tabs .inner-content p { margin: 0; }  .order-tabs .inner-content p:before { content: "|"; margin: 0 5px; }  .order-tabs .inner-content .link { color: #000; font-weight: bold; text-decoration: underline; }  .order-tabs .inner-content .link:before { content: "|"; margin: 0 5px; font-weight: normal; pointer-events: none; }  .table-selector { list-style: none; margin: 0; padding: 20px 10px; display: flex; align-items: center; font-weight: bold; font-size: 11px; border-top: 1px solid #e1e1e1; }  .table-selector li { margin: 0 15px 0 0; }  .table-selector a { color: #000; text-decoration: none; }  .table-selector a.delete { color: #003567; }  .table-selector a i { font-weight: normal; }  .table-selector .slds-checkbox .slds-checkbox__label .slds-form-element__label { color: #000; }  .slds-modal__footer .btn-default { min-width: 75px; border-radius: 0; } @media only screen and (max-width: 1299px) { .catalog-results { display: block; }  .search-results { padding: 0; } } @media only screen and (max-width: 991px) {  .search-results { overflow-x: auto; }  .search-results-wrap { min-width: 935px; overflow: hidden; } }'
        htmlText+='<head><style> '+  css +'  </style> <style> '+  css2 +' </style> <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>';
        htmlText+=`  <script>
            $(document).ready(function() { 
            $('.saved-lists .saved-opener').on('click', function() { $(this).toggleClass('active');
                                                                    $(this).siblings('.dropdown').slideToggle(); }); 
            $('.alerts-accordion .opener').click(function() { debugger 
            $(this).toggleClass('active');
                                                             $(this).siblings('.line-items-content').slideToggle(); 
                                                             $(this).closest('li').siblings('li').find('.line-items-content').slideUp(); 
                                                             $(this).closest('li').siblings('li').find('.opener').removeClass('active'); }); 
            $('.tabset a').on('click', function(event) { 
                event.preventDefault(); 
                $(this).closest('li').siblings('li').removeClass('active');
                $(this).parent().toggleClass('active');
                $($(this).attr('href')).toggleClass('tab-active').siblings().removeClass('tab-active'); }); });
        </script>` 
        
        htmlText+= '</head><body>';
        htmlText += component.find("toPrint").getElements()[0].innerHTML
        
        htmlText+='</body></html>';
        document.getElementById('vfiframe').style['display'] = 'block'
        var message = []
        message.push(component.get('v.orderId'))
        message.push(htmlText);
        var vfOrigin = "https://b2bdev-horizonhobbysupport.cs166.force.com";
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        vfWindow.postMessage(message, vfOrigin);
        
        
        component.set("v.isPDFShow",true)
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Downloading!",
            "mode": "pester",
            "type":"success",
            "duration": 2000,
            "message": "PDF is downloading..."
        });
        toastEvent.fire();
        component.set("v.printAllpdf",htmlText)
        
        component.set("v.showPrintModal", false);
    },
    
    printHTML : function(component, event, helper){
        //window.print()
        
        
        var htmlText = '<html>';
        var p = getComputedStyle(component.find("toPrint").getElements()[0])
        // var css = '.slds-table{'
        debugger
        // css+='}th, td {  border-bottom: 1px solid #ddd;}.slds-text-title_bold{ font-size:8pt; float:center}';
        // var css ='.slds-text-title_bold{ font-weight: bold; font-size:8pt } body{ font-size:8pt }  th, td { overflow: hidden;padding:0px;border-bottom: 1px solid #ddd; padding-left: 3px; margin: 0px; width: auto; white-space: nowrap; max-width: 110px;  }  .slds-p-around_medium h1 { padding: 0px; width:50%; text-align:center } .slds-table{ width : 52%;font-size: 9pt; }'
        var css ='.cart-page { padding:15px; background: #fff;} .cart-page h2 { font-size: 28px; line-height: 32px; font-weight: bold; margin: 0 0 20px; }  .cart-details { display: flex; align-items: flex-start; }  .cart-details .cart-head { display: flex; align-items: center; margin: 0 0 10px; }  .cart-details .items-details { width: 75%; padding-right: 20px; }  .summary-details { background: #e1e1e1; padding: 15px; text-align: center; width: 25%; }  .shipping-progress { margin: 0 0 25px; }  .shipping-progress .shipping-title { display: block; margin: 0 0 5px; font-size: 12px; font-weight: normal; }  .shipping-progress .shipping-title .shipping-status { color: #003567; font-weight: bold; text-transform: uppercase; }  .summary-details .title{ font-size: 20px; line-height: 22px; margin: 0 0 15px; display: block; }  .order-summary-list { list-style: none; padding: 0; margin: 0 0 15px; }  .order-summary-list li { display: flex; margin: 0 0 8px; }  .order-summary-list li .sub-title { flex-grow: 1; padding: 0 5px 0 0; text-align: left; }  .order-summary-list li.totals { font-weight: bold; }  .summary-details .btn-default{ display: block; text-decoration: none; }  .progress-bar { width: 100%; height: 5px; position: relative; background: #fff; }  .progress-bar .status { position: relative; height: 5px; left: 0; top: 0; bottom: 0; background: #003567; } /*line item*/  .line-item { display: flex; flex-flow: row wrap; margin: 0 -5px; }  .line-item .col { width: 33.333%; padding: 0 5px; }  .line-item dl { overflow: hidden; }  .line-item dl dt { font-weight: bold; width: 70%; float: left; margin: 0 0 5px; }  .line-item dl dd { overflow: hidden; margin: 0 0 5px; }  .line-item dl sup { margin: -2px 0 0; vertical-align: top; display: inline-block; font-size: 75%; }  .line-item .form-control { width: 100%; outline: none; resize: none; height: 38px; color: #000000; border-radius: 3px; border: 1px solid #e1e1e1; padding: 10px; margin: 0 0 15px; }  .line-item textarea.form-control { height: 160px; }  .saved-lists { background: #fff; font-size: 12px; line-height: 14px; font-weight: 500; position: relative; }  .saved-lists .saved-opener { padding: 10px; display: block; color: #003567; text-decoration: none; margin: 0 0 -3px; }  .saved-lists .saved-opener span:before { color: #003567; display: block; margin: 0 0 0 2px; transition: all 0.3s ease-in-out; }  .saved-lists .saved-opener.active span:before { transform: rotate(-180deg); }  .saved-lists .dropdown { display: none; padding: 0 10px; position: absolute; left: -1px; width: 420px; top: calc(100% - 1px); border: 1px solid #7d7d7d; background: #fff; z-index: 2; max-height: 400px; overflow: auto; }  .dropdown .slds-table_bordered { border: 0; color: #000; font-size: 13px; }  .dropdown .slds-cell-fixed { position: static; }  .dropdown .slds-table thead th { color: #000; padding: 0; border-bottom: 1px solid #e1e1e1; }  .dropdown .slds-truncate a{ color: #000; }  .dropdown .slds-table thead th .slds-cell-fixed { padding: 15px 0; }  .dropdown .slds-table_bordered tbody td { padding: 15px 0; border: 0; min-height: 61px; }  .dropdown .slds-table_bordered tbody td:last-child { text-align: right; }  .dropdown .slds-table_bordered tbody tr:hover td { box-shadow: none; background: none; }  .dropdown .slds-table_bordered tbody tr + tr td { border-top: 1px solid #dcdcdc; }  .edit-item { position: relative; margin: 2px 0 0; }  .edit-item .edit-dropdown { padding: 10px; background: #fff; position: absolute; left: 8px; top: 100%; width: 300px; display: flex; margin-top: 2px; z-index: 1; border: 1px solid #1e1e1e; }  .edit-item .edit-dropdown .slds-form-element__control { padding: 0 10px 0 0; }  .edit-item .edit-dropdown .slds-input { height: 40px; }  .edit-item .edit-dropdown .btn-default { min-width: 90px; text-align: center; border-radius: 3px; }  .edit-item .edit-dropdown .slds-form-element__label:empty { display: none; }  .greyOut{ pointer-events: none; background: #CCC; color: #333; border: 1px solid #666 } .slds-hidden { display: none; }  .slds-is-relative { z-index:1; } .catalog-results { display: flex; }  .search-results { padding: 0 0 0 15px; }  .prev,  .next { width: 31px; height: 33px; border: 0; background: #000; color: #fff; border-radius: 0; position: relative; padding:0; font-size: 0; line-height: 0; }  .prev:before,  .next:after { content: ""; font-family: "Font Awesome 5 Pro"; color: #fff; position: absolute; font-size: 20px; line-height: 32px; }  .next:after { content: "ff54"; }  .items-count { text-align: right; padding: 0 10px; }  .paging a{ color: #000; }  .paging b a { margin: 0 3px; text-decoration: underline; }  .custom-select { display: inline-block; vertical-align: middle; width: 98px; }  .custom-select select { width: 100%; min-width: 100%; padding: 5px 15px 5px 5px; }  .custom-select.num { width: 60px; margin: 0 0 0 8px; }  .custom-checkbox { display: inline-block; vertical-align: middle; margin:0 15px 0 0; }  .checkbox-row { display: flex; }  .select-row { display: flex; justify-content: flex-end; }  .print-list { list-style: none; margin:0; padding:0; display: flex; }  .print-list li + li:before { content:"|"; margin: 0 5px; }  .export-options { display: flex; justify-content: center; font-size: 12px; font-weight: 500; } .slds-is-relative { margin: 0 0 15px; }  .export-options .sub-title { padding: 0 3px 0 15px; }  .export-options a{ color: #000; text-decoration: underline; } .items-head td { padding: 15px 0; }  .slds-table { border: 1px solid #e1e1e1; }  .slds-table thead th { vertical-align: top; }  .slds-table thead th { width: 35px; }  .slds-table thead th:first-child { max-width: 10px; }  .slds-table thead th:nth-child(2) { max-width: 30px; }  .slds-table thead th:nth-child(8)  { width: 130px; }  .slds-table tbody td,  .slds-table thead th { color: #000; font-size: 12px; line-height: 18px; font-weight: 700; padding: 5px 5px 5px 0; border-top: 0; }  .slds-table thead th { padding: 15px 10px; border-bottom: 1px solid #e1e1e1; }  .slds-table thead th .slds-th__action { padding: 0; height: auto; /* white-space: normal;*/ }  .slds-table tbody td { font-weight: 400; padding: 10px 5px; }  .slds-table tbody td.slds-cell-edit { padding-left: 10px; }  .slds-table tbody tr:hover td { background: #fff; box-shadow: none !important; }  .slds-table tbody tr + tr td { border-top: 1px solid #e1e1e1; }  .slds-cell-edit .slds-popover { width: 70px; box-shadow: none; border-radius: 0; position: static !important; border: 0; }  .slds-cell-edit .slds-popover input { text-align: center; border-radius: 0; border-color: #e1e1e1; outline: none; }  .slds-popover_edit .slds-popover__body { padding: 0; }  .slds-popover .slds-form-element__control button { border: 0; color: #000; outline: none; }  .slds-popover .slds-form-element__control button:focus{ box-shadow: none; }  .slds-popover .slds-form-element__control .slds-input__button_decrement { left: 5px; }  .slds-popover .slds-form-element__control .slds-input__button_increment { right: 5px; }  .search-selects-footer { padding: 5px; display: flex; align-items: center; justify-content: center; background: linear-gradient(90deg, rgba(188,186,186,1) 0%, rgba(225,225,225,1) 100%); }  .search-selects-footer .btn-default { border-radius: 0; margin:0 5px; font-size: 12px; }  .search-selects-footer .slds-button_neutral:hover { color: #fff; background: #003567; }  .search-selects-footer .btn-default.clear { background: #7d7d7d; }  .items-summary { list-style: none; padding: 0; margin: 0; display: flex; align-items: center; }  .items-summary li { padding: 0 10px; position: relative; }  .items-summary li + li:before { content: "|"; position: absolute; left: 0; top: 0; }  .filters-selected { padding: 8px; margin: 20px 0; display: inline-block; vertical-align: top; border: 1px solid #7d7d7d; }  .filters-selected .title { display: inline-block; vertical-align: top; padding: 0 8px; background: #fff; margin: -20px 0 20px; }  .filters-selected .links-area { display: inline-flex; vertical-align: middle; align-items: center; padding: 0 0 0 20px; }  .filters-selected .links-area .btn-default { border-radius: 0; position:relative; padding: 7px 15px; }  .filters-selected .links-area .btn-default:before { content: ""; font-family: "Font Awesome 5 Pro"; margin: -2px 6px 0 0; display: inline-block; vertical-align: middle; }  .filters-selected .links-area .clear-all { color: #7d7d7d; font-weight: 500; margin: 0 0 0 15px; text-decoration: underline; }  .filters-selected .filters-content { display: flex; align-items: flex-start; margin: -15px 0 0; }  .tags-list { list-style: none; padding: 7px 0 0 0; margin: 0 -8px; display: inline-flex; flex-flow: row wrap; font-weight: 500; flex-grow: 1; flex-basis: 0; }  .tags-list li { padding: 4px 8px; }  .tags-list li a { color: #000; margin: 0 0 0 5px; } .print-modal .slds-modal__container{ max-width: 595px; min-width: inherit; width: auto; padding: 10px; } .print-modal .slds-modal__header { text-align: left; border-bottom: 1px solid #f4f4f4; padding: 0 0 10px; margin: 0 0 20px; } .print-modal .slds-modal__close { position: static; float: right; margin: -5px 0 0; } .print-modal .slds-modal__close .slds-button_icon-inverse { color: #000; width: 20px; height: 20px; } .print-modal .slds-theme_default { padding: 15px; } .print-modal .slds-modal__title { color: #333; font-size: 18px; line-height: 22px; font-weight: 700; } .print-modal .btn-default { border-radius: 0; } .print-modal .slds-modal__content:last-child { box-shadow: none; padding: 0; border-radius: 0; }  .order-info { display: flex; align-items: center; flex-flow: row wrap; flex-grow: 1; }  .order-info .title { color: #003567; font-size: 20px; line-height: 22px; }  .order-info .item-numbers { font-size: 20px; line-height: 22px; padding: 0 5px; }  .order-info .edit { color: #003567; margin: 0 8px; }  .cart-import-export { display: flex; }  .cart-import-export li + li:before { content: "|"; margin: 0 8px; color: #000; }  .cart-import-export li a { color: #000; }' 
        var css2 = '/*order alerts*/  .order-alerts { padding: 15px; background: #fefcf3; border-top: 1px solid #e1e1e1; }  .order-alerts h2 { display: inline-block; vertical-align: top; margin: 0 0 20px; }  .order-alerts h2 span { margin: 0 10px; text-decoration: underline; }  .order-alerts h2:after,  .order-alerts h2:before { content: "!"; color: #e9cd0e; font-weight: 900; }  .alerts-accordion { list-style: none; margin: 0; padding: 0; letter-spacing: -0.32em; }  .alerts-accordion > li { margin: 0 5px 10px; background: #fff; width: calc(50% - 10px); border: 1px solid #e1e1e1; display: inline-block; vertical-align: top; letter-spacing: 0; }  .alerts-accordion .opener { color: #000; display: flex; align-items: center; padding: 10px 40px 10px 10px; position: relative; text-decoration: none; }  .alerts-accordion .opener:after { content: "+"; position: absolute; right: 10px; top: 15px; font-size: 25px; }  .alerts-accordion .opener.active:after { content: "--"; top: 13px; right: 13px; letter-spacing: -2px; }  .alerts-accordion .opener .icon { width: 26px; }  .alerts-accordion .opener .title { padding: 0 0 0 8px; }  .alerts-accordion .opener .title:after { content: "|"; margin: 0 5px; }  .alerts-accordion .line-items-content { display: none; padding: 10px; font-size: 10px; line-height: 14px; }  .alerts-accordion .items-list { list-style: none; margin: 0 0 5px; padding: 0; }  .alerts-accordion ul.items-list li:nth-of-type(1n+4) {display: none;}  .alerts-accordion ul.items-list.ShowAll li:nth-of-type(1n+4) {display: block;}  .alerts-accordion .show-more { color: #000; font-weight: bold; text-decoration: underline; }  .alerts-accordion .show-more:before { content: "+"; margin: 0 3px 0 0; }  .alerts-accordion .show-less:before { content: "-"; margin: 0 3px 0 0; }  .order-tabs { padding: 8px 10px; background: #fefcf3; border: 1px solid #e1e1e1; }  .tabset { list-style: none; padding: 0; margin: 0; display: inline-flex; border-bottom: 1px solid #e1e1e1; }  .tabset li { margin: 0 5px 0 0; }  .tabset li:last-child { margin: 0; }  .tabset li a { width: 26px; display: block; text-decoration: none; padding: 0 0 3px; margin: 0 0 -1px; border-bottom: 2px solid transparent; }  .tabset li.active a { border-bottom-color: #000; }  .tabset li img { width: 100%; height: auto; }  .order-tabs .tab-pane { display: none; }  .order-tabs .tab-pane.tab-active { display: block; }  .order-tabs .inner-content { display: flex; padding: 5px 0; }  .order-tabs .title:before { content: "!"; color: #e9cd0e; font-weight: 900; margin: 0 5px 0 0; }  .order-tabs .inner-content p { margin: 0; }  .order-tabs .inner-content p:before { content: "|"; margin: 0 5px; }  .order-tabs .inner-content .link { color: #000; font-weight: bold; text-decoration: underline; }  .order-tabs .inner-content .link:before { content: "|"; margin: 0 5px; font-weight: normal; pointer-events: none; }  .table-selector { list-style: none; margin: 0; padding: 20px 10px; display: flex; align-items: center; font-weight: bold; font-size: 11px; border-top: 1px solid #e1e1e1; }  .table-selector li { margin: 0 15px 0 0; }  .table-selector a { color: #000; text-decoration: none; }  .table-selector a.delete { color: #003567; }  .table-selector a i { font-weight: normal; }  .table-selector .slds-checkbox .slds-checkbox__label .slds-form-element__label { color: #000; }  .slds-modal__footer .btn-default { min-width: 75px; border-radius: 0; } @media only screen and (max-width: 1299px) { .catalog-results { display: block; }  .search-results { padding: 0; } } @media only screen and (max-width: 991px) {  .search-results { overflow-x: auto; }  .search-results-wrap { min-width: 935px; overflow: hidden; } }'
        htmlText+='<head><style> '+  css +'  </style> <style> '+  css2 +' </style> <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script> <link href="https://cdnjs.cloudflare.com/ajax/libs/design-system/2.17.1/styles/salesforce-lightning-design-system-imports.sanitized.min.css"  rel="stylesheet"/>';
        htmlText+=`  <script>
            $(document).ready(function() { 
            $('.saved-lists .saved-opener').on('click', function() { $(this).toggleClass('active');
                                                                    $(this).siblings('.dropdown').slideToggle(); }); 
            $('.alerts-accordion .opener').click(function() { debugger 
            $(this).toggleClass('active');
                                                             $(this).siblings('.line-items-content').slideToggle(); 
                                                             $(this).closest('li').siblings('li').find('.line-items-content').slideUp(); 
                                                             $(this).closest('li').siblings('li').find('.opener').removeClass('active'); }); 
            $('.tabset a').on('click', function(event) { 
                event.preventDefault(); 
                $(this).closest('li').siblings('li').removeClass('active');
                $(this).parent().toggleClass('active');
                $($(this).attr('href')).toggleClass('tab-active').siblings().removeClass('tab-active'); }); });
        </script>` 
        htmlText+= ' <link href="https://b2bdev-horizonhobbysupport.cs166.force.com/horizonhobby/s/sfsites/l/%7B%22mode%22%3A%22PROD%22%2C%22app%22%3A%22siteforce%3AcommunityApp%22%2C%22loaded%22%3A%7B%22APPLICATION%40markup%3A%2F%2Fsiteforce%3AcommunityApp%22%3A%22HCtMHh401rafCyJjOw40pw%22%7D%2C%22styleContext%22%3A%7B%22c%22%3A%22webkit%22%2C%22x%22%3A%5B%22isDesktop%22%5D%2C%22tokens%22%3A%5B%22markup%3A%2F%2Fsiteforce%3AserializedTokens%22%2C%22markup%3A%2F%2Fforce%3AsldsTokens%22%2C%22markup%3A%2F%2Fsiteforce%3AcommunityTokens%22%2C%22markup%3A%2F%2Fforce%3AformFactorLarge%22%2C%22markup%3A%2F%2Fsiteforce%3AcommunityFormFactorLarge%22%2C%22markup%3A%2F%2Fsiteforce%3AauraDynamicTokens%22%2C%22markup%3A%2F%2Fsiteforce%3AsldsFontOverride%22%5D%2C%22tuid%22%3A%22VFOJZcy1OF3lasoZiVJVGw%22%2C%22cuid%22%3A-923788153%7D%2C%22pathPrefix%22%3A%22%2Fhorizonhobby%22%7D/app.css?aura.attributes=%7B%22schema%22%3A%22Published%22%2C%22brandingSetId%22%3A%22884f8f97-f926-4773-a26e-3c7949fb1045%22%2C%22authenticated%22%3A%22true%22%2C%22formFactor%22%3A%22LARGE%22%2C%22publishedChangelistNum%22%3A%22164%22%2C%22viewType%22%3A%22Published%22%2C%22themeLayoutType%22%3A%22wnzOow3HqYL4DEVMHHtI1T525v7fG1%22%2C%22language%22%3A%22en_US%22%2C%22isHybrid%22%3A%22false%22%2C%22pageId%22%3A%22189f5489-49f5-41d8-8ee5-2f781daa7987%22%7D&2"  rel="stylesheet"/></head><body>';
        htmlText += component.find("toPrint").getElements()[0].innerHTML
        htmlText = htmlText.replaceAll('▼','')
        htmlText = htmlText.replaceAll('€','&#128;')
        
        htmlText = htmlText.replaceAll('lightning-formatted-number','span')
        htmlText = htmlText.replaceAll('/lightning-formatted-number','/span')
        htmlText = htmlText.replace('<th data-aura-rendered-by="183:2;a">Select</th>','<th data-aura-rendered-by="183:2;a"></th>')
        htmlText+='</body></html>';
        var action = component.get("c.downloadFile")
        
        action.setParams({ HtmlText : htmlText});
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Downloading!",
                    "mode": "pester",
                    "type":"success",
                    "duration": 2000,
                    "message": "HTML is downloading..."
                });
                toastEvent.fire();
                let downloadLink = document.createElement("a");
                downloadLink.href = "data:text/html;base64,"+response.getReturnValue();
                
                downloadLink.download = "filename.html";
                downloadLink.click();
                
                component.set("v.showPrintModal", false);
                
                
            }
        } );
        
        $A.enqueueAction(action); 
    },
    
    openModal : function(component, event, helper) {
        var data = component.get("v.data") 
        if(data.length > 0){
            component.set("v.isExcel",false) 
            
            component.set("v.isHtml",false) 
            
            component.set("v.isPDFShow",false) 
            component.set("v.showPrintModal",true) ;
            debugger
            if(event.target.id == 'exportcsv'){
                component.set("v.isExcel",true) 
            }
            else if(event.target.id == 'exporthtml'){
                component.set("v.isHtml",true) 
            }
                else {
                    component.set("v.isPDFShow",true) 
                }
        }
        
    },
    
    closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showPrintModal", false);
    },
    
    closeModal2 : function(component, event, helper){
        if(event.target.tagName == 'SECTION' ||(event.target.tagName == 'DIV' && event.target.classList[0] =='slds-modal__container') )
            component.set("v.showPrintModal", false);
    },
    
    openModalImport: function(component,event,helper){
        component.set("v.showImportModal",false);  
        debugger;
      	component.set("v.showImportModal",true);  
        //component.set("v.isImportModalOpen",true);  
    },
    closeImportModal: function(component,event,helper){
        debugger;
      	component.set("v.showImportModal",false);
          //     component.set("v.isImportModalOpen",false);  
    },
    
    tabClickHandler:function (component, event, helper){
        debugger
        component.set('v.isParentCheckAll',false)
        component.set('v.isCheckAll',false)
        component.find('parentSelectAll').set('v.checked',component.get('v.isCheckAll'))
        
        var SelectedValues =  component.get("v.SelectedValues");
        SelectedValues = []
        component.set("v.SelectedValues",SelectedValues);
        var mainData =  component.get("v.copyOfData");
        component.set('v.data',mainData)
        if(event.currentTarget.closest('li').className == ''){
            var name = event.currentTarget.getAttribute('id')
            var data = component.get('v.AlertGroupData')
            var datetoShowontable =data.find(x=>x.alertName == name)
            component.set('v.data',datetoShowontable.items)
        }
    }
    
})