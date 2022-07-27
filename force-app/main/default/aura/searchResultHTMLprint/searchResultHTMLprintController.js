({
    init : function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "DD-MM-YYYY");
        component.set('v.today', today);
        var category = helper.getUrlParameter(component,'category')  === true ? '' : helper.getUrlParameter(component,'category');
        
        var manufacturer = helper.getUrlParameter(component,'manufacturer') === true ? '' : helper.getUrlParameter(component,'manufacturer') ;
        var keyword = helper.getUrlParameter(component,'keyword') === true ? '' : helper.getUrlParameter(component,'keyword');
        var filterId = helper.getUrlParameter(component,'FilterId')=== true ? '' :    helper.getUrlParameter(component,'FilterId')
        var table = helper.getUrlParameter(component,'table')=== true ? '' :    helper.getUrlParameter(component,'table')
        
        if(table == 'orderSumary' || table == 'orderSumaryBackOrder')
        {
            component.set('v.isSummary',true);
            if(table == 'orderSumary'){
                component.set("v.isBackOrder", false);
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
            } else if(table == 'orderSumaryBackOrder'){
                component.set("v.isBackOrder", true);
                component.set('v.columns', [
                        //    {label: 'imageLink', fieldName: 'PrimaryImageLink', type: 'text'},
                        
                        {label: 'Order #', type: 'text'},
                        {
                            label: 'Item #', type: 'text',    
                            
                        },
                        {label: 'PO#', type: 'text'},
                        
                        //{label: 'Description', type: 'text'},
                        {label: 'Open Qty', type: 'number'},
                        {label: 'Availability', type: 'text'},
                        {label: 'Unit Price', type: 'text'},
                        {label: 'Total Price', type: 'text'},
                        {label: 'Order Date', type: 'text'},
                        {label: 'Prefered Ship Date', type: 'date'},
                        
                        
                        
                        
                    ]);
            }
            
            
            
        
        var action = component.get("c.getOrders");
        if(table == 'orderSumary'){
         	action.setParams({ isBackOrder : false});          
      	} else if(table == 'orderSumaryBackOrder'){
        	action.setParams({ isBackOrder : true});         
        }
        
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
                    if(table == 'orderSumaryBackOrder'){
                    data.forEach(function(item,index, object){
                        item.Order.CreatedDate = new Date(item.Order.CreatedDate).toLocaleDateString("en-UK").replaceAll('/', '-');

                    })
                    }
                    var all = helper.getUrlParameter(component,'all')
                    var start;
                    var end;
                    if (all =='false'){
                        start =helper.getUrlParameter(component,'start')
                        start = parseInt(start)
                        end =helper.getUrlParameter(component,'end') 
                        end = parseInt(end)
                    }
                    console.log('SUCCESS: getProductList');
                    
                    var filteredProductList = [];
                  
                    
                    if (all == 'false'){
                        data = data.slice(start,end+1)
                    }
                    
                    component.set("v.data", data);
                    

                    
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
        $A.enqueueAction(action); 
        
        }
        else{
            var a = component.get('c.filter');
            $A.enqueueAction(a);
            
            if ( category || manufacturer || keyword|| filterId) {
                
                
                component.set( "v.keyword", keyword ); 
                component.set( "v.categorySelectedValue", category ); 
                component.set( "v.manufacturerSelectedValue", manufacturer );  
                
                component.set('v.FilterId',filterId)
                var a = component.get('c.filter');
                $A.enqueueAction(a);
            }
            
            component.set('v.columns', [
                //    {label: 'imageLink', fieldName: 'PrimaryImageLink', type: 'text'},
                
                {label: 'Item', fieldName: 'linkName', type: 'url',  typeAttributes: {label: { fieldName: 'ProductName' }, target: '_blank', required: true }},
                
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
        var locale = $A.get("$Locale.language");
        
        if(locale != 'en'){
            helper.getTranslation(component, event, helper)
            
        }
    },
    print : function(component, event, helper){
        //window.print()
        
        component.set('v.isHtml',true)
        var htmlText = '<html>';
        var p = getComputedStyle(component.find("printTab").getElements()[0])
        // var css = '.slds-table{'
        
        // css+='}th, td {  border-bottom: 1px solid #ddd;}.slds-text-title_bold{ font-size:8pt; float:center}';
        // var css ='.slds-text-title_bold{ font-weight: bold; font-size:8pt } body{ font-size:8pt }  th, td { overflow: hidden;padding:0px;border-bottom: 1px solid #ddd; padding-left: 3px; margin: 0px; width: auto; white-space: nowrap; max-width: 110px;  }  .slds-p-around_medium h1 { padding: 0px; width:50%; text-align:center } .slds-table{ width : 52%;font-size: 9pt; }'
        var css ='.slds-text-title_bold{ font-weight: bold; font-size:8pt } body{ font-size:8pt }  th, td { text-align: inherit;overflow: hidden;padding:0px;border-bottom: 1px solid #ddd; padding-left: 3px; margin: 0px; width: auto; white-space: nowrap; max-width: 110px;  }   .slds-table{ width : 100%;font-size: 9pt; } .slds-p-around_medium h1 { padding: 0px;  text-align:center } '
        
        htmlText+='<head><style> '+  css +' </style></head><body>';
        htmlText += component.find("printTab").getElements()[0].innerHTML
        htmlText+='</body></html>';
        var action = component.get("c.downloadHtmlFile")
        
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
                
                component.set('v.isHtml',true)
                
            }
        } );
        
        $A.enqueueAction(action); 
    },
    filter:function (component, event, helper) {
        var param = null;
        const params = [];
        var caseNo = 0;
        console.log('test1');
        var category = component.get('v.categorySelectedValue')
        var manufacturer = component.get('v.manufacturerSelectedValue')
        var FilterId=  component.get('v.FilterId') ;
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
        
        
        
        var action = component.get("c.getProductList");
        action.setParams({
            recIds : params,
            caseNo : caseNo,
            keyword: component.get("v.keyword"),
            
            filterID: FilterId
        });
        action.setCallback(this, function(response) {
            var pageSize = component.get("v.pageSize");
            
            var state = response.getState();
            if(state == 'SUCCESS'){
                debugger 
                var productList = response.getReturnValue();
                if(productList.length > 0){
                    var all = helper.getUrlParameter(component,'all')
                    var start;
                    var end;
                    if (all =='false'){
                        start =helper.getUrlParameter(component,'start')
                        start = parseInt(start)
                        end =helper.getUrlParameter(component,'end') 
                        end = parseInt(end)
                    }
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
                                                item.pbe.Product2.LastUpdated__c = new Date(item.pbe.Product2.LastUpdated__c).toLocaleDateString("en-GB").replaceAll('/', '-');
                                                item.pbe.Product2.ETA__c =  new Date(item.pbe.Product2.ETA__c).toLocaleDateString("en-GB").replaceAll('/', '-');
                                                
                                            }
                                        },this);
                    
                    for(var i = 0 ; i < indexArray.length; i++){
                        productList.splice(indexArray[i],1);
                    }
                    
                    
                    var data = productList;
                    if (all == 'false'){
                        data = data.slice(start,end+1)
                    }
                    
                    component.set("v.data", data);
                    
                    
                }
            }
        });
        $A.enqueueAction(action); 
        
        
    }
    
})