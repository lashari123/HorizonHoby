({  
    scriptsLoaded : function(component, event, helper) {
        component.set("v.isLoaded", true);
    }, 
    
    closeModal2 : function(component, event, helper){
          if(event.target.tagName == 'SECTION' ||(event.target.tagName == 'DIV' && event.target.classList[0] =='slds-modal__container')  )
            component.set("v.showPrintModal", false);
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
    
    ClearRenderedList : function(component, event, helper) {
        var emptyList = [];
        component.set("v.renderedList",emptyList);
        var a = component.get('c.filter');
        $A.enqueueAction(a);
        
    },
    
    refreshData :function(component, event, helper){
        component.set("v.data", component.get("v.data"));
    },
    
    print : function(component, event, helper){
        //window.print()
        //
        var navService = component.find( "navService" );  
        var FilterId = component.get("v.FilterId")
        var keyword= component.get( "v.keyword" ); 
        var Category= component.get( "v.categorySelectedValue" ); 
        var Maufacture= component.get( "v.manufacturerSelectedValue" ); 
        var all = 'true';
        if(event.target.id != 'all'){
            all = 'false'
        }
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
                end : ''+component.get("v.end")
                
            }  
        }; 
        
        //      navService.navigate( pageReference ); 
        navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            window.open(url, "_blank");
        }), $A.getCallback(function(error) {
            cmp.set("v.url", defaultUrl);
        }));  
         component.set("v.showPrintModal",false)
        /*    component.set('v.isHtml',true)
        var htmlText = '<html>';
        var p = getComputedStyle(component.find("printTab").getElements()[0])
        var css = '.slds-table{'
      
       css+='}th, td {  border-bottom: 1px solid #ddd;}';
        htmlText+='<head><sfetyle> '+  css +' </style></head><body>';
        htmlText += component.find("printTab").getElements()[0].innerHTML
        htmlText+='</body></html>';
        var action = component.get("c.getHtmlFile")
        
        action.setParams({ HtmlText : htmlText});
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let downloadLink = document.createElement("a");
                downloadLink.href = "data:text/html;base64,"+response.getReturnValue();
                downloadLink.download = "filename.html";
                downloadLink.click();
                
              
                
                component.set('v.isHtml',true)
        
            }
        } );
            
            $A.enqueueAction(action); */
    },
    
    getFilterValues : function(component, event, helper) {
        component.set("v.renderedList", event.getParam("FilterValues"));
    },
    
    init: function (cmp, event, helper) {
        var catName = helper.getUrlParameter(cmp,'catName');
        
        cmp.set('v.sortColumns', [
            //    {label: 'imageLink', fieldName: 'PrimaryImageLink', type: 'text'},
            
            {label: 'Item', fieldName: 'linkName', type: 'url',  typeAttributes: {label: { fieldName: 'ProductName' }, target: '_blank', required: true }},
            {
                label: 'QTY', fieldName: 'Quantity', type: 'number', editable: true,    
                
            },
            {label: 'Description', fieldName: 'Description', type: 'text'},
            
            {label: 'Retail', fieldName: 'retail', type: 'currency', typeAttributes: { currencyCode: 'USD'},  typeAttributes: { required: true }, } ,
            {label: 'Dealer', fieldName: 'dealer', type: 'currency', typeAttributes: { currencyCode: 'USD'}, typeAttributes: { required: true} },
            //   {label: 'Multi', fieldName: 'PrimaryImageLink', type: 'text'},
            {label: 'Avail', fieldName: 'Avail__c', type: 'text'},
            {label: 'ETA', fieldName: 'ETA__c', type: 'text'},
            
            {label: 'Shipcode', fieldName: 'ShippingClass__c', type: 'text'},
            //   {label: 'Kill/Part', fieldName: 'PrimaryImageLink', type: 'text'},
            
            {label: 'CAT', fieldName: 'category', type: 'text'},
            
            {label: 'Status', fieldName: 'InventoryStatus__c', type: 'text'},
            
            {label: 'UPC', fieldName: 'UPC__c', type: 'text'},
            {label: 'Updated Date', fieldName: 'LastUpdated__c', type: 'text'},
            {label: 'Rank', fieldName: 'Rank__c', type: 'text'}
            
        ]);
        
        
        //    var a =  pageReference.state.firstName;
        //  var b= pageReference.state.lastName;
        var action1 = cmp.get("c.isDealerPricing");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS'){
                cmp.set("v.ShowDealer",response.getReturnValue())
                 if(cmp.get("v.ShowDealer") == true){
            cmp.set('v.columns', [
                //    {label: 'imageLink', fieldName: 'PrimaryImageLink', type: 'text'},
                
                {label: 'Item', fieldName: 'linkName', type: 'url',  typeAttributes: {label: { fieldName: 'ProductName' }, target: '_blank', required: true }},
                {
                    label: 'QTY', fieldName: 'Quantity', type: 'number', editable: true,    
                    
                },
                {label: 'Description', fieldName: 'Description', type: 'text'},
                
                {label: 'Retail', fieldName: 'retail', type: 'currency', typeAttributes: { currencyCode: 'USD'},  typeAttributes: { required: true }, } ,
                {label: 'Dealer', fieldName: 'dealer', type: 'currency', typeAttributes: { currencyCode: 'USD'}, typeAttributes: { required: true} },
                //   {label: 'Multi', fieldName: 'PrimaryImageLink', type: 'text'},
                {label: 'Avail', fieldName: 'Avail__c', type: 'text'},
                {label: 'ETA', fieldName: 'ETA__c', type: 'text'},
                
                {label: 'Shipcode', fieldName: 'ShippingClass__c', type: 'text'},
                //   {label: 'Kill/Part', fieldName: 'PrimaryImageLink', type: 'text'},
                
                {label: 'CAT', fieldName: 'category', type: 'text'},
                
                {label: 'Status', fieldName: 'InventoryStatus__c', type: 'text'},
                
                {label: 'UPC', fieldName: 'UPC__c', type: 'text'},
                {label: 'Updated Date', fieldName: 'LastUpdated__c', type: 'text'},
                {label: 'Rank', fieldName: 'Rank__c', type: 'text'}
                
                
                
                
            ]);
        }
        else
        {
             cmp.set('v.columns', [
                //    {label: 'imageLink', fieldName: 'PrimaryImageLink', type: 'text'},
                
                {label: 'Item', fieldName: 'linkName', type: 'url',  typeAttributes: {label: { fieldName: 'ProductName' }, target: '_blank', required: true }},
                {
                    label: 'QTY', fieldName: 'Quantity', type: 'number', editable: true,    
                    
                },
                {label: 'Description', fieldName: 'Description', type: 'text'},
                
                {label: 'Retail', fieldName: 'retail', type: 'currency', typeAttributes: { currencyCode: 'USD'},  typeAttributes: { required: true }, } ,
               // {label: 'Dealer', fieldName: 'dealer', type: 'currency', typeAttributes: { currencyCode: 'USD'}, typeAttributes: { required: true} },
                //   {label: 'Multi', fieldName: 'PrimaryImageLink', type: 'text'},
                {label: 'Avail', fieldName: 'Avail__c', type: 'text'},
                {label: 'ETA', fieldName: 'ETA__c', type: 'text'},
                
                {label: 'Shipcode', fieldName: 'ShippingClass__c', type: 'text'},
                //   {label: 'Kill/Part', fieldName: 'PrimaryImageLink', type: 'text'},
                
                {label: 'CAT', fieldName: 'category', type: 'text'},
                
                {label: 'Status', fieldName: 'InventoryStatus__c', type: 'text'},
                
                {label: 'UPC', fieldName: 'UPC__c', type: 'text'},
                {label: 'Updated Date', fieldName: 'LastUpdated__c', type: 'text'},
                {label: 'Rank', fieldName: 'Rank__c', type: 'text'}
                
                
                
                
            ]);
            
        }
            }
        });
        $A.enqueueAction(action1); 
    
          
        
        
        if(cmp.get("v.ShowQuantity") == true){
            cmp.set('v.columns', [
                //    {label: 'imageLink', fieldName: 'PrimaryImageLink', type: 'text'},
                
                {label: 'Item', fieldName: 'linkName', type: 'url',  typeAttributes: {label: { fieldName: 'ProductName' }, target: '_blank', required: true }},
                {
                    label: 'QTY', fieldName: 'Quantity', type: 'number', editable: true,    
                    
                },
                {label: 'Description', fieldName: 'Description', type: 'text'},
                
                {label: 'Retail', fieldName: 'retail', type: 'currency', typeAttributes: { currencyCode: 'USD'},  typeAttributes: { required: true }, } ,
                {label: 'Dealer', fieldName: 'dealer', type: 'currency', typeAttributes: { currencyCode: 'USD'}, typeAttributes: { required: true} },
                //   {label: 'Multi', fieldName: 'PrimaryImageLink', type: 'text'},
                {label: 'Avail', fieldName: 'Avail__c', type: 'text'},
                {label: 'ETA', fieldName: 'ETA__c', type: 'text'},
                
                {label: 'Shipcode', fieldName: 'ShippingClass__c', type: 'text'},
                //   {label: 'Kill/Part', fieldName: 'PrimaryImageLink', type: 'text'},
                
                {label: 'CAT', fieldName: 'category', type: 'text'},
                
                {label: 'Status', fieldName: 'InventoryStatus__c', type: 'text'},
                
                {label: 'UPC', fieldName: 'UPC__c', type: 'text'},
                {label: 'Updated Date', fieldName: 'LastUpdated__c', type: 'text'},
                {label: 'Rank', fieldName: 'Rank__c', type: 'text'}
                
                
                
                
            ]);
        }
        else
        {
            cmp.set('v.columns', [
                //  {label: 'imageLink', fieldName: 'PrimaryImageLink', type: 'text'},
                
                {label: 'Item', fieldName: 'linkName', type: 'url',  typeAttributes: {label: { fieldName: 'ProductName' }, target: '_blank', required: true }},
                
                
                {label: 'Retail', fieldName: 'UnitPrice', type: 'currency', typeAttributes: { currencyCode: 'USD'},  typeAttributes: { required: true }, } ,
                {label: 'Map', fieldName: 'UnitPrice', type: 'currency', typeAttributes: { currencyCode: 'USD'}, typeAttributes: { required: true} },
                {label: 'Net', fieldName: 'UnitPrice', type: 'currency', typeAttributes: { currencyCode: 'USD'}, typeAttributes: { required: true } }
                
                
            ]);
            
        }
        if(cmp.get("v.ShowQuantity") == false){
            var action = cmp.get("c.getList");
            
            action.setParams({ type : cmp.get('v.TableName')});
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data =  response.getReturnValue();
                    
                    data.forEach(function(item)
                                 {
                                     item.ProductName = item.Product2.Name;
                                     item.linkName = '/horizonhobby/s/product/'+item.Product2Id;
                                     item.PrimaryImageLink = item.Product2.PrimaryImageID__c;
                                     item.ProductCode = item.Product2.ProductCode
                                 });
                    cmp.set("v.data", data);
                    
                }
            });
            
            $A.enqueueAction(action); 
        }
        var action = cmp.get("c.getCategories");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS'){
                var CategoryList = response.getReturnValue();
                if(CategoryList.length > 0){
                    cmp.set("v.categoryList",CategoryList);
                    
                    
                    var category = helper.getUrlParameter(cmp,'category')  === true ? '' : helper.getUrlParameter(cmp,'category');
                    
                    var manufacturer = helper.getUrlParameter(cmp,'manufacturer') === true ? '' : helper.getUrlParameter(cmp,'manufacturer') ;
                    var keyword = helper.getUrlParameter(cmp,'keyword') === true ? '' : helper.getUrlParameter(cmp,'keyword');
                    var a = cmp.get('c.filter');
                    $A.enqueueAction(a);
                    if ( category || manufacturer || keyword) {
                        
                        
                        cmp.set( "v.keyword", keyword ); 
                        cmp.set( "v.categorySelectedValue", category ); 
                        cmp.set( "v.manufacturerSelectedValue", manufacturer );  
                        var a = cmp.get('c.filter');
                        $A.enqueueAction(a);
                        
                    }
                }
                if(catName){
                    
                    cmp.set("v.catName", 'Top Selling Category');
                    var selectedcat = CategoryList.filter(item => item.Name == 'Top Selling Category')
                    var selectedId = selectedcat[0].Id;
                    cmp.set("v.categorySelectedValue", selectedId);
                    
                    var a = cmp.get('c.filter');
                    $A.enqueueAction(a);
                }
            }
        });
        $A.enqueueAction(action); 
        
        //Getting Manufacturers for Manufacturer Filter Dropdown
        var action = cmp.get("c.getManufacturers");
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state == 'SUCCESS'){
                var manufacturerList = response.getReturnValue();
                if(manufacturerList.length > 0){
                    cmp.set("v.manufacturerList",manufacturerList);
                    var category = helper.getUrlParameter(cmp,'category')  === true ? '' : helper.getUrlParameter(cmp,'category');
                    
                    var manufacturer = helper.getUrlParameter(cmp,'manufacturer') === true ? '' : helper.getUrlParameter(cmp,'manufacturer') ;
                    var keyword = helper.getUrlParameter(cmp,'keyword') === true ? '' : helper.getUrlParameter(cmp,'keyword');
                    var filterId = helper.getUrlParameter(cmp,'FilterId')
                    if ( category || manufacturer || keyword|| filterId) {
                        
                        
                        cmp.set( "v.keyword", keyword ); 
                        cmp.set( "v.categorySelectedValue", category ); 
                        cmp.set( "v.manufacturerSelectedValue", manufacturer );  
                        
                        cmp.set('v.FilterId',filterId)
                        var a = cmp.get('c.filter');
                        $A.enqueueAction(a);
                    }
                }  
            }
            
        });
        $A.enqueueAction(action); 
        
        // language Translation
        var locale = $A.get("$Locale.language");
        
        if(locale != 'en'){
            helper.getTranslation(cmp, event, helper)
            
        }
        
    },
    
    addToCartHandler : function (cmp,event,helper){
        var action = cmp.get('c.generateListForProducts');
        action.setParams({ products : cmp.get('v.SelectedValues')});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var res = response.getReturnValue();
                if(res!=null){
                    console.log('SUCCESS: generateListForProducts');
                    var prodList = res;
                    cmp.set("v.skuQuantityList", prodList);
                    if(prodList.length > 0){    
                        cmp.set("v.showAddToDraftOrder",true);
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
        
        
        /*let data = cmp.get('v.SelectedValues').map((obj) => obj.Product2Id);
        
        var action = cmp.get("c.addToCart");
        action.setParams({ 
            products :  cmp.get('v.SelectedValues'),
            productsId : data
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var cid = response.getReturnValue();
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/cart/"+cid
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);*/
    },
    
    handleSaveEdition: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        
        var component = cmp.find("searchTab");
        var SelectedValues = cmp.get('v.SelectedValues');
        var SelectedIDs =  cmp.get('v.selectedRows');
        
        SelectedIDs.push(draftValues[0].Product2Id);
        SelectedValues.push(draftValues[0]);
        cmp.set('v.SelectedValues',SelectedValues);
        component.set("v.selectedRows", SelectedIDs);
        
        
        
    },
    
    getSelectedName: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        // Display that fieldName of the selected rows
        for (var i = 0; i < selectedRows.length; i++){
            //  alert("You selected: " + selectedRows[i].opportunityName);
        }
    },
    
    categorySelected:function (component, event, helper) {
        component.set("v.keyword",'')
        var category = event.getSource().get("v.value");
        component.set("v.categorySelectedValue", category);
        console.log('category: ' +category);
    },
    
    runningFilter:function (component, event, helper) {
        var a = component.get('c.filter');
        $A.enqueueAction(a);
    },
    
    filter:function (component, event, helper) {
        var param = null;
        const params = [];
        var caseNo = 0;
        if(component.get("v.renderedList").length == 0){
            console.log('test1');
            var category = component.find('category').get('v.value');
            var manufacturer = component.find('manufacture').get('v.value');
            var FilterId=  component.get('v.FilterId');
            if(category != null && category != undefined && category != '' && manufacturer != null && manufacturer != undefined && manufacturer != ''){
                caseNo = 1;
                category = 'categories_' + category;
                manufacturer = 'manufacturers_' + manufacturer;
                params.push(category,manufacturer);
            } else if((category == null || category == undefined || category == '') && (manufacturer != null && manufacturer != undefined && manufacturer != '')){
                caseNo = 2;
                manufacturer = 'manufacturers_' + manufacturer;
                params.push(manufacturer);
                param = manufacturer;
            } else if((category != null && category != undefined && category != '') && (manufacturer == null || manufacturer == undefined || manufacturer == '')){
                caseNo = 3;
                category = 'categories_' + category;
                params.push(category);
                param = category;
            }
        } 
        else {
            var isCategory = false;
            var isProductAttribute = false;
            var renderedList = component.get("v.renderedList");
            renderedList.forEach(function(item)
                                 {
                                     if(caseNo != 1){
                                         if(item.value.split('_')[0] == 'categories'){
                                             isCategory = true;
                                         }
                                         if(item.value.split('_')[0] != 'categories'){
                                             isProductAttribute = true;
                                         }
                                         if(isCategory && isProductAttribute){
                                             caseNo = 1;
                                         }
                                     }
                                     params.push(item.value.split('_')[0] + '_' + item.value.split('_')[2]);
                                     
                                 });
            if(caseNo != 1 && isCategory){
                caseNo = 3;
            }else if(caseNo != 1 && isProductAttribute){
                caseNo = 2;
            }
            ;
            var category = component.find('category').get('v.value');
            if(category != null && category != undefined && category != ''){
                if(!isCategory){
                    category = 'categories_' + category;
                    params.push(category);
                    if(caseNo == 2){
                        caseNo = 1;
                    }
                }
            }
            var manufacture = component.find('manufacture').get('v.value');
            if(manufacture != null && manufacture != undefined && manufacture != ''){
                manufacture = 'manufacturers_' + manufacture;
                params.push(manufacture);
                if(caseNo == 3){
                    caseNo = 1;
                }
            }
        }
        
        var action = component.get("c.getProductList");
        action.setParams({
            recIds : params,
            caseNo : caseNo,
            keyword: component.get("v.keyword"),
            
            filterID: component.get("v.FilterId")
        });
        action.setCallback(this, function(response) {
            var pageSize = component.get("v.pageSize");
            
            var state = response.getState();
            if(state == 'SUCCESS'){
                debugger 
                var productList = response.getReturnValue();
                if(productList.length > 0){
                    console.log('SUCCESS: getProductList');
                    
                    var filteredProductList = [];
                    var indexArray=[]
                    productList.forEach(function(item,index, object)
                                        {	
                                            if(item.pbe == null || item.pbe == undefined || item.pbe.Product2.Name == null || item.pbe.Product2.Name == undefined){
                                                indexArray.push(index)
                                            }
                                            else{
                                                item.ProductName = item.pbe.Product2.Name;
                                                filteredProductList.push(item.pbe.Product2.Id);
                                                item.PrimaryImageLink ='../servlet/servlet.FileDownload?file='+ item.pbe.Product2.PrimaryImageID__c;
                                                item.ProductCode = item.pbe.Product2.ProductCode
                                                item.Quantity = ''
                                                item.pbe.Product2.LastUpdated__c = new Date(item.pbe.Product2.LastUpdated__c).toLocaleDateString("en-UK").replaceAll('/', '-');
                                                item.pbe.Product2.ETA__c =  new Date(item.pbe.Product2.ETA__c).toLocaleDateString("en-UK").replaceAll('/', '-');;
                                            }
                                        },this);
                    
                    for(var i = 0 ; i < indexArray.length; i++){
                        productList.splice(indexArray[i],1);
                    }
                    
                    var data = productList;
                    if(component.get("v.filteredProductList").length==0){
                        component.set("v.filteredProductList", filteredProductList);
                        component.set("v.showSearchFilter", true);
                    }
                    // alert(component.get("v.filteredProductList").length);
                    
                    var discontinuedList = data.filter(item =>item.pbe.Product2.InventoryStatus__c == 'DISC')
                    
                    component.set("v.discontinuedList",discontinuedList)
                    
                    var inStockList = data.filter(item =>item.pbe.Product2.Avail__c == 'Y')
                    component.set("v.inStockList",inStockList)
                    
                    data = data.filter(item =>item.pbe.Product2.InventoryStatus__c != 'DISC')
                    component.set("v.data", data);
                    component.set("v.SelectedValues", null);
                    component.set("v.totalAmountSelected",0)
                    
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
            } else if (state === "ERROR") {
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
        
    },
    
    onPageNoClick : function(component, event, helper) {
        
        var selected = event.currentTarget.innerHTML
        
        
        var paginationList = [];
        var pageSize = component.get("v.pageSize");
        var datalist = component.get("v.data");
        var start = pageSize*(parseInt(selected)-1)
        var end = start+ (pageSize-1);
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
        var grandChildCmp = component.find("aComp").find('cComp');
        grandChildCmp.UpdateCheckbox(field, fieldIterator);
        
        var a = component.get('c.filter');
        $A.enqueueAction(a);
        /*var compEvent = component.getEvent("UpdateCheckboxEvent");  
        compEvent.setParams({
            "field" : field,
            "fieldIterator" : fieldIterator
        });
        compEvent.fire();
        //Unchecking from Attribute checkbox
        var valueSelected = component.find(field).get("v.value");
    	valueSelected.splice(fieldIterator, 1);
        component.find(field).set("v.value", valueSelected);*/
    },
    
    SaveList:function (component, event, helper) {
        component.set("v.showFilterList",true);
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
    
    closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showPrintModal", false);
    },
   
    openModal : function(component, event, helper) {
           event.stopPropagation();
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
   
    getToggleButtonValue : function(component, event, helper){
        debugger
        var isInstock = component.find('InStockTglbtn').getElements()[0].checked
        var isDiscontinue = component.find('DiscontinuedTglbtn').getElements()[0].checked
        /* var toggle =event.currentTarget.name;
        
        
        var pageSize = component.get("v.pageSize");
        var data = component.get("v.data");
        
        var checked = event.currentTarget.checked;
        
        if(toggle == 'InStockTglbtn')
        {
            
            if(checked){
                
                component.set("v.beforeToggleList", data);
                data = data.filter(item =>item.pbe.Product2.Avail__c == 'Y')
            }
            else{
                data = component.get("v.beforeToggleList")
            }
            
        }
        else
        {
            if(checked){
                
                component.set("v.beforeToggleList", data);
                data = data.filter(item =>item.pbe.Product2.InventoryStatus__c == 'DISC')
            }
            else{
                data = component.get("v.beforeToggleList")
                
            }
        }
	*/
        
        var beforeToggleList = component.get("v.beforeToggleList");
        var data = component.get("v.data");
        if(beforeToggleList.length>0){
            data = beforeToggleList
        }
        var inStockList = component.get("v.inStockList");
        var discontinuedList = component.get("v.discontinuedList");
        
        var toShowList = []
        if(isDiscontinue || isInstock){
            if(isDiscontinue){
                toShowList.push.apply(toShowList,discontinuedList)
                toShowList.push.apply(toShowList,data)
            }
            if(isInstock){
                toShowList.push.apply(toShowList,inStockList)
            }
            component.set("v.beforeToggleList", data);
        }
        else if(isDiscontinue == false && isInstock == false){
            toShowList.push.apply(toShowList,data)
        }
        // toShowList = new Set(toShowList);
        let noDup = [...new Set(toShowList)];
        component.set("v.data", noDup);
        
        helper.paginateData(component, event, helper);
        
    },
        
});