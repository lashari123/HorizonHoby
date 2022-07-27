({
    init: function (component, event, helper) {
        debugger;
        var type= helper.getUrlParameter('type');
        //alert(type);
        /**
        var a = component.get('c.changeTypeInit');
        a.setParam('itemType', type);
        $A.enqueueAction(a);
        **/
        //helper.changeTypeInit(component,event,helper,type);
        
        
        component.set('v.columns', [
            //    {label: 'imageLink', fieldName: 'PrimaryImageLink', type: 'text'},
            
            {label: 'Order Date', fieldName: 'EffectiveDate', type: 'text'},
            {
                label: 'Order #', fieldName: 'OrderNumber', type: 'text',    
                
            },
            {label: 'PO#', fieldName: 'PoNumber', type: 'text'},
            
            {label: 'Total lines', fieldName: 'Order_Line_Items_Count__c', type: 'text'},
            {label: 'Total(value)', fieldName: 'TotalAmount', type: 'text'},
            {label: 'Shipped(value)', fieldName: 'ShippedValue', type: 'text'},
            {label: 'Remaining Open(value)', fieldName: 'open', type: 'text'},
            {label: 'Cancelled', fieldName: 'Cancelled', type: 'text'},
            {label: 'Prefered Ship Date', fieldName: 'ship Date', type: 'text'},
            {label: 'Status', fieldName: 'Status', type: 'text'},
            {label: 'Invoice', fieldName: 'Cancelled', type: 'text'}
            
            
            
        ]);
        var action = component.get("c.getOrders");
        action.setParams({ isBackOrder : false});
        action.setCallback(this, function(response) {
            var pageSize = component.get("v.pageSize");
            
            var state = response.getState();
            if(state == 'SUCCESS'){
                debugger 
                var productList = response.getReturnValue();
                productList = JSON.parse(productList)
                if(productList.length > 0){
                    console.log('SUCCESS: getProductList');
                    
                    
                    
                    var data = productList;
                    data.forEach(function(item,index, object){
                        item.EffectiveDate = new Date(item.EffectiveDate).toLocaleDateString("en-UK").replaceAll('/', '-');
                        
                    })
                    
                    component.set("v.data", data);
                    component.set("v.mainData", data);
                    
                    component.set("v.totalSize", data.length);
                    var totalPages = Math.ceil(data.length/parseInt(pageSize));
                    
                    component.set("v.totalPages", totalPages)
                    if(totalPages >5)
                    {
                        totalPages = 5
                    }
                    
                    component.set("v.totalPagesList", Array.from({length: totalPages}, (_, i) => i + 1))
                    component.set("v.start",0);
                    component.set("v.pageSize", pageSize)
                    
                    pageSize = pageSize<data.length ?pageSize:data.length
                    component.set("v.end",pageSize-1);
                    
                    
                    helper.setheaderCounterText(component, event, helper);
                    
                    var paginationList = [];
                    
                    for(var i=0; i< pageSize; i++)
                        
                    {
                        
                        paginationList.push(data[i]);
                        
                    }
                    
                    component.set("v.paginationList", paginationList);
                    
                    
                } 
                var arr = []
                component.set('v.SelectedValues',arr);
                component.set("v.selectedRows",arr );
                component.set("v.draftValues", arr);
                
                //set filter of order view:
                if(type!=undefined){
                helper.changeTypeInit(component,event,helper,type);
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
        });
        $A.enqueueAction(action); 
        
        
        
        
        //Getting Manufacturers for Manufacturer Filter Dropdown
        // language Translation
        var locale = $A.get("$Locale.language");
        
        if(locale != 'en'){
            
        }
        
    },
    
    getFilteredOrder : function(component, event, helper) {
        debugger
        
        var item = component.find("searchInput").getElements()[0].value;
        
        var data = component.get("v.mainData");
        var isBackOrder = component.get("v.isBackOrder");
        
            //data = data.filter(x=> x.OrderNumber.indexOf(item) > -1 || x.PoNumber.indexOf(item) > -1)
         if(isBackOrder){
             data = data.filter(function (currentElement) {
                if (currentElement.Order.OrderNumber.indexOf(item) > -1 || (currentElement.Order.PoNumber != null && currentElement.Order.PoNumber.indexOf(item) > -1) || (currentElement.Product2.ProductCode != null && currentElement.Product2.ProductCode.indexOf(item) > -1) || (currentElement.Product2.Description != null && currentElement.Product2.Description.indexOf(item) > -1) ) {
                    return true;
                }
            });
         }else{
            data = data.filter(function (currentElement) {
                if (currentElement.OrderNumber.indexOf(item) > -1 || (currentElement.PoNumber != null && currentElement.PoNumber.indexOf(item) > -1) || (currentElement.Description != null && currentElement.Description.indexOf(item) > -1) ) {
                    return true;
                }
            });         
         }
        
        
        
        component.set("v.data",data);
        helper.paginateData(component, event, helper);
        helper.setheaderCounterText(component, event, helper);
        /*
        var action = component.get("c.getOrders");
        
        action.setParams({ isBackOrder : true, term : component.find("searchInput").getElements()[0].value});
        action.setCallback(this, function(response) {
            var pageSize = component.get("v.pageSize");
            
            var state = response.getState();
            if(state == 'SUCCESS'){
                debugger 
                var productList = response.getReturnValue();
                productList = JSON.parse(productList)
                if(productList.length > 0){
                    console.log('SUCCESS: getOrders');
                    
                    
                    
                    var data = productList;
                    data.forEach(function(item,index, object){
                        item.EffectiveDate = new Date(item.EffectiveDate).toLocaleDateString("en-UK").replaceAll('/', '-');
                        
                    })
                    
                    component.set("v.data", data);
                    component.set("v.mainData", data);
                    
                    component.set("v.totalSize", data.length);
                    var totalPages = Math.ceil(data.length/parseInt(pageSize));
                    
                    component.set("v.totalPages", totalPages)
                    if(totalPages >3)
                    {
                        totalPages = 3
                    }
                    
                    component.set("v.totalPagesList", Array.from({length: totalPages}, (_, i) => i + 1))
                    component.set("v.start",0);
                    component.set("v.pageSize", pageSize)
                    
                    pageSize = pageSize<data.length ?pageSize:data.length
                    component.set("v.end",pageSize-1);
                    
                    
                    helper.setheaderCounterText(component, event, helper);
                    
                    var paginationList = [];
                    
                    for(var i=0; i< pageSize; i++)
                        
                    {
                        
                        paginationList.push(data[i]);
                        
                    }
                    
                    component.set("v.paginationList", paginationList);
                    
                    
                } 
                var arr = []
                component.set('v.SelectedValues',arr);
                component.set("v.selectedRows",arr );
                component.set("v.draftValues", arr);
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
        });
        $A.enqueueAction(action); */
    },
    
    getBackOrder : function(component, event, helper) {
    	var action = component.get("c.getOrders");
        action.setParams({ isBackOrder : true});
        action.setCallback(this, function(response) {
            var pageSize = component.get("v.pageSize");
            
            var state = response.getState();
            if(state == 'SUCCESS'){
                debugger 
                var productList = response.getReturnValue();
                productList = JSON.parse(productList)
                if(productList.length > 0){
                    console.log('SUCCESS: getProductList');
                    
                    
                    
                    var data = productList;
                    data.forEach(function(item,index, object){
                        item.Order.CreatedDate = new Date(item.Order.CreatedDate).toLocaleDateString("en-UK").replaceAll('/', '-');
                        if(item.Order.EndDate){
                            item.Order.EndDate = new Date(item.Order.EndDate).toLocaleDateString("en-UK").replaceAll('/', '-');
                        }

                    })
                    
                    component.set("v.isBackOrder", true);
                    
                    // Changing class of both buttons in order to change css
                    var buttonElement = component.find("allOrders");
                    $A.util.removeClass(buttonElement, 'active');
                    
                    var buttonElement2 = component.find("openBackOrders");
					$A.util.addClass(buttonElement2, "active");
                    
                    component.set('v.columns', [
                        //    {label: 'imageLink', fieldName: 'PrimaryImageLink', type: 'text'},
                        
                        {label: 'Order #', fieldName: 'OrderNumber', type: 'text'},
                        {label: 'Item #',  fieldName: 'ProductCode',type: 'text'},
                        {label: 'PO#',  fieldName: 'PoNumber',type: 'text'},
                        
                        //{label: 'Description', type: 'text'},
                        {label: 'Open Qty', fieldName: 'opened__c', type: 'number'},
                        {label: 'Availability', fieldName: 'avail__c', type: 'text'},
                        {label: 'Unit Price', fieldName: 'UnitPrice', type: 'text'},
                        {label: 'Total Price', fieldName: 'TotalPrice', type: 'text'},
                        {label: 'Order Date', fieldName: 'OrderDate', type: 'date'},
                        {label: 'Prefered Ship Date', fieldName: 'EndDate', type: 'date'},
                        
                        
                        
                        
                    ]);
                    
                    // Emptying filter fields
                    component.find("from").getElements()[0].value = '';
                    component.find("to").getElements()[0].value = '';
                    component.find("searchInput").getElements()[0].value = '';
                    
                    component.set("v.data", data);
                    component.set("v.mainData", data);
                    
                    component.set("v.totalSize", data.length);
                    var totalPages = Math.ceil(data.length/parseInt(pageSize));
                    
                    component.set("v.totalPages", totalPages)
                    if(totalPages >5)
                    {
                        totalPages = 5
                    }
                    
                    component.set("v.totalPagesList", Array.from({length: totalPages}, (_, i) => i + 1))
                    component.set("v.start",0);
                    component.set("v.pageSize", pageSize)
                    
                    pageSize = pageSize<data.length ?pageSize:data.length
                    component.set("v.end",pageSize-1);
                    
                    
                    helper.setheaderCounterText(component, event, helper);
                    
                    var paginationList = [];
                    
                    for(var i=0; i< pageSize; i++)
                        
                    {
                        
                        paginationList.push(data[i]);
                        
                    }
                    
                    component.set("v.paginationList", paginationList);
                    
                    
                } 
                var arr = []
                component.set('v.SelectedValues',arr);
                component.set("v.selectedRows",arr );
                component.set("v.draftValues", arr);
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
        });
        $A.enqueueAction(action); 
        
	},
    
    onSelectChange : function(component, event, helper) {
        
        var selected = component.find("records").getElements()[0].value
        
        var paginationList = [];
        
        var datalist = component.get("v.data");
        
        var totalPages = Math.ceil(datalist.length/parseInt(selected));
        component.set("v.totalPages", Math.ceil(datalist.length/parseInt(selected)));
        
        
        
        component.set("v.totalPages", totalPages)
        if(totalPages >5)
        {
            totalPages = 5
        }
        
        component.set("v.totalPagesList", Array.from({length: totalPages}, (_, i) => i + 1))
        
        
        selected = selected<datalist.length ?selected:datalist.length
        for(var i=0; i< selected; i++)
            
        {
            
            paginationList.push(datalist[i]);
            
        }
        
        var pageSize = component.set("v.pageSize",selected);
        component.set("v.start",0);
        
        component.set("v.end",parseInt(selected)-1);
        component.set('v.paginationList', paginationList);
        component.set("v.currentPage",1);
        helper.setheaderCounterText(component, event, helper);
    },
    
    changeType : function(component, event, helper) {
        debugger
        
        var item = event.currentTarget.value
        
        var data = component.get("v.mainData");
        if(item == 'Order History'){
           
            
        }
        else{
            data = data.filter(x=> x.Status == item)
        }
        
        component.set("v.data",data);
        helper.paginateData(component, event, helper);
        helper.setheaderCounterText(component, event, helper);
        
    },
     dateChange : function(component, event, helper) {
        debugger
        
        var isBackOrder = component.get("v.isBackOrder");
        var from =  document.getElementById('from').value
        var to =  document.getElementById('to').value
        
        var data = component.get("v.mainData");
        if(from == '' || to == ''){
           
            
        }
        else{
            if(isBackOrder){
                data = data.filter(function (currentElement) {
                    var dateSplit = from.split('-');
                    var f = dateSplit[2] + '-' + dateSplit[1] + '-' + dateSplit[0];
                    dateSplit = to.split('-');
                    var t = dateSplit[2] + '-' + dateSplit[1] + '-' + dateSplit[0];
                    if (currentElement.Order.CreatedDate >= f && currentElement.Order.CreatedDate <= t ) {
                        return true;
                    }
            	});
               // data = data.filter(x=> x.Order.CreatedDate >= from && x.Order.CreatedDate  <= to)
            }else{
            	data = data.filter(x=> x.CreatedDate >= from && x.CreatedDate  <= to)
            }
        }
        
        component.set("v.data",data);
        helper.paginateData(component, event, helper);
        helper.setheaderCounterText(component, event, helper);
        
    },
    
    first : function(component, event, helper){
        component.set("v.currentPage",1);
        var datalist = component.get("v.data");
        
        var pageSize = parseInt(component.get("v.pageSize"));
        
        var paginationList = [];
        
        for(var i=0; i< pageSize; i++)
            
        {
            
            paginationList.push(datalist[i]);
            
        }
        
        component.set('v.paginationList', paginationList);
        
        component.set("v.start",0);
        
        component.set("v.end",parseInt(pageSize)-1);
        helper.setheaderCounterText(component, event, helper);
    },
    
    last : function(component, event, helper)    {
        
        var datalist = component.get("v.data");
        
        var pageSize = parseInt(component.get("v.pageSize"));
        
        var totalSize = component.get("v.totalSize");
        
        var totalPages = component.get("v.totalPages");
        
        component.set("v.currentPage",totalPages);
        
        var paginationList = [];
        
        for(var i=totalSize-(pageSize); i< totalSize; i++)
            
        {
            
            paginationList.push(datalist[i]);
            
        }
        
        component.set('v.paginationList', paginationList);
        
        component.set("v.start",totalSize-1);
        component.set("v.end",totalSize-1);
        
        helper.setheaderCounterText(component, event, helper);
    },
    
    next : function(component, event, helper){
        
        var datalist = component.get("v.data");
        
        var end = component.get("v.end");
        
        var start = component.get("v.start");
        
        
        component.get("v.totalPages")
        var currentPage = component.get("v.currentPage");
        
        component.set("v.currentPage",currentPage+1);
        
        
        var pageSize = parseInt(component.get("v.pageSize"));
        
        var paginationList = [];
        
        var counter = 0;
        
        for(var i=end+1; i<end+pageSize+1; i++)
            
        {
            
            if(datalist.length > end)
                
            {
                
                paginationList.push(datalist[i]);
                
                counter ++ ;
                if((pageSize*currentPage) + counter >= datalist.length){
                    break
                }
                
            }
            
        }
        
        start = start + counter;
        
        end = end + counter;
        
        component.set("v.start",start);
        
        component.set("v.end",end);
        
        component.set('v.paginationList', paginationList);
        
        helper.setheaderCounterText(component, event, helper);
        helper.checkPageNoList(component, event, helper);
        
    },
    
    previous : function(component, event, helper){
        
        var start = component.get("v.start");
        var datalist = component.get("v.data");
        
        var end = component.get("v.end");
        
        var pageSize = parseInt(component.get("v.pageSize"));
        
        var currentPage = component.get("v.currentPage");
        
        component.set("v.currentPage",currentPage-1);
        var paginationList = [];
        
        var counter = 0;
        
        for(var i= start-pageSize; i < start ; i++)
            
        {
            
            if(i > -1)
                
            {
                
                paginationList.push(datalist[i]);
                
                counter ++;
                
            }
            
            else {
                
                start++;
                
            }
            
        }
        
        start = start - counter;
        
        end = end - counter;
        
        component.set("v.start",start);
        
        component.set("v.end",end);
        
        component.set('v.paginationList', paginationList);
        
        helper.setheaderCounterText(component, event, helper);
        
        helper.checkPageNoList(component, event, helper,'pre');
        
    },
    
    onPageNoClick : function(component, event, helper) {
        
        var selected = event.currentTarget.innerHTML
        
        
        var paginationList = [];
        var pageSize = component.get("v.pageSize");
        var datalist = component.get("v.data");
        var start = pageSize*(parseInt(selected)-1)
        var end = start+ (pageSize-1);
        component.set("v.currentPage",parseInt(selected));
        component.set("v.totalPages", Math.ceil(datalist.length/parseInt(selected)));
        selected = selected<datalist.length ?selected:datalist.length
        for(var i=start; i<= end; i++)
            
        {
            
            paginationList.push(datalist[i]);
            
        }
        
        
        component.set("v.start",start);
        
        component.set("v.end",end);
        component.set('v.paginationList', paginationList);
        
        helper.setheaderCounterText(component, event, helper);
        
    },
    
    headerClick:function (component, event, helper){
        debugger
        var id = event.currentTarget.getAttribute('id')
        console.log(id) 
        component.find("sort").getElements()[0].value = id.split('|')[0];
        if(event.currentTarget.innerHTML.includes("▼")){
            event.currentTarget.innerHTML = event.currentTarget.innerHTML.slice(0,-2) + " ▲"
        }
        else{
            event.currentTarget.innerHTML = event.currentTarget.innerHTML.slice(0,-2) + " ▼"
            
        }
        helper.onSortChange(component, event, helper, id.split('|')[1])
        
    },
    
    generatePDF : function(component, event, helper) {
        component.set("v.isPDFShow",false)
        
        if(event.target.id == 'all'){
            component.set('v.printAll',true)
        }else{
            component.set('v.printAll',false)
        }
        component.set("v.isPDFShow",true)
        component.set("v.showPrintModal",false)
        
        
    },
    
    closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showPrintModal", false);
    },
    
    openModal : function(component, event, helper) {
        var linkName = event.currentTarget.getAttribute('id')
        if(linkName == 'PDF'){
            component.set("v.heading",'PDF Print')
            component.set("v.isHTML",false)
            component.set("v.isExcel",false) 
            component.set("v.isPDF",true)
        }
        else if (linkName == 'HTML'){
            
            component.set("v.heading",'HTML Print')
            component.set("v.isPDF",false)
            component.set("v.isExcel",false) 
            component.set("v.isHTML",true)
        }
            else{
                component.set("v.heading",'Excel Print')
                
                component.set("v.isPDF",false)
                component.set("v.isHTML",false) 
                component.set("v.isExcel",true) 
            }
        
        component.set("v.showPrintModal",true)
    },
     closeModal2 : function(component, event, helper){
          if(event.target.tagName == 'SECTION' ||(event.target.tagName == 'DIV' && event.target.classList[0] =='slds-modal__container')  )
            component.set("v.showPrintModal", false);
    },
    
    print : function(component, event, helper){
        //window.print()
        //
        var navService = component.find( "navService" );  
        var FilterId = component.get("v.FilterId")
        var keyword= component.get( "v.keyword" ); 
        var Category= component.get( "v.categorySelectedValue" ); 
        var Maufacture= component.get( "v.manufacturerSelectedValue" ); 
        var isBackOrder= component.get( "v.isBackOrder" ); 
        var all = 'true';
        if(event.target.id != 'all'){
            all = 'false'
        }
        if(isBackOrder){
            var pageReference = {  
            type: "comm__namedPage",  
            attributes: {  
                pageName: "printhtml"  
            },  
            state: {  
                FilterId : FilterId,
                keyword : keyword,
                category : Category,
                maufacture :Maufacture,
                all: all,
                start : ''+component.get("v.start"),
                end : ''+component.get("v.end"),
                table :'orderSumaryBackOrder'
                
            }  
        }; 
        } else{
            var pageReference = {  
            type: "comm__namedPage",  
            attributes: {  
                pageName: "printhtml"  
            },  
            state: {  
                FilterId : FilterId,
                keyword : keyword,
                category : Category,
                maufacture :Maufacture,
                all: all,
                start : ''+component.get("v.start"),
                end : ''+component.get("v.end"),
                table :'orderSumary'
                
            }  
        }; 
        }
        
        
        //      navService.navigate( pageReference ); 
        navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            window.open(url, "_blank");
        }), $A.getCallback(function(error) {
            cmp.set("v.url", defaultUrl);
        }));  
        component.set("v.showPrintModal",false)
        
    },
    openModalImport: function(component,event,helper){
        debugger;
      	component.set("v.showImportModal",true);  
        //component.set("v.isImportModalOpen",true);  
    },
    closeImportModal: function(component,event,helper){
        debugger;
      	component.set("v.showImportModal",false);
          //     component.set("v.isImportModalOpen",false);  
    },
    
    NewOrder: function(component,event,helper){
        debugger;
        component.set("v.newOrder",true);
        location.assign("/horizonhobby/s/new-order");
       /* var pageReference = {  
            type: "comm__namedPage",  
            attributes: {  
                pageName: "NewOrder"  
            }
        }; 
        navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            window.open(url, "_blank");
        }), $A.getCallback(function(error) {
            cmp.set("v.url", defaultUrl);
        }));  */
    },
    changeTypeInit : function(component, event, helper,itemType) {
        debugger
        
        var item = itemType;
        
        var data = component.get("v.mainData");
        if(item == 'Order History'){
            
            
        }
        else{
            data = data.filter(x=> x.Status == item)
        }
        
        component.set("v.data",data);
        helper.paginateData(component, event, helper);
        helper.setheaderCounterText(component, event, helper);
        
    },
})