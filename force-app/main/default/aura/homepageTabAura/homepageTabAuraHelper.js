({
    getTopSellingList : function(cmp, event, helper) {
        var action = cmp.get("c.getLists");
        action.setParams({
                          filter : "topSelling",
                          noOfRows : cmp.get("v.noOfRows")
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data =  response.getReturnValue();
                data.forEach(function(item) {
                    ;
                    item.name = item.name
                    item.stockkeepingunit = item.StockKeepingUnit
                    item.linkName = '/horizonhobby/s/product-detail-page?pid='+item.product2Id;
                    
                   
                });
                cmp.set("v.topsellingData", data);  
            }
        });
        $A.enqueueAction(action);
    },
    
    getNewReleaseList : function(cmp, event, helper) {
        var action = cmp.get("c.getLists");
        action.setParams({ 
                          filter : "newRelease",
                          noOfRows : cmp.get("v.noOfRows")
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data =  response.getReturnValue();
                data.forEach(function(item) {
                    ;
                    item.name = item.name
                    item.stockkeepingunit = item.StockKeepingUnit
                    item.linkName = '/horizonhobby/s/product-detail-page?pid='+item.product2Id;
                });
                cmp.set("v.newreleaseData", data);
            }
        });
        $A.enqueueAction(action);
    },
    
    getNewStockList : function(cmp, event, helper) {
        var action = cmp.get("c.getLists");
        action.setParams({ 
                          filter : "newstocks",
                          noOfRows : cmp.get("v.noOfRows")
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data =  response.getReturnValue();
                data.forEach(function(item) {
                    ;
                    item.name = item.name
                    item.stockkeepingunit = item.StockKeepingUnit
                    item.linkName = '/horizonhobby/s/product-detail-page?pid='+item.product2Id;
                });
                cmp.set("v.newstockData", data.reverse());
            }
        });
        $A.enqueueAction(action);
    },
    
    getColumns : function(cmp, event, helper,transaltedData){
        
        var action = cmp.get("c.getLabels");
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data =  response.getReturnValue();
                
                cmp.set('v.newreleaseColumns', [
                    
                  //  {label: data['stockkeepingunit'], fieldName: 'stockKeepingUnit', type: 'text'},
                    {label: data['name'], fieldName: 'linkName', type: 'url', 
                     typeAttributes: { label: { fieldName: 'name' }, }},
                    {label: data['description'], fieldName: 'description', type: 'text'},
                    {label: transaltedData['Retail'], fieldName: 'retail', type: 'currency'},
                    {label:transaltedData['Dealer'], fieldName: 'dealer', type: 'currency'},
                    {label: transaltedData['Release Date'], fieldName: 'releaseDate', type: 'text'}
                    
                ]);
                
                cmp.set('v.topsellingColumns', [
                    
                    
                    {label: data['name'], fieldName: 'linkName', type: 'url', 
                     typeAttributes: { label: { fieldName: 'name' }, }},
                    {label: data['description'], fieldName: 'description', type: 'text'},
                    {label: transaltedData['Retail'], fieldName: 'retail', type: 'currency'},
                    {label:  transaltedData['Dealer'], fieldName: 'dealer', type: 'currency'}   
                    
                ]); 
                
                
                if(cmp.get("v.isPrice") == false){
                    debugger
                    var newreleaseColumns=   cmp.get('v.newreleaseColumns');
                    var topsellingColumns=  cmp.get('v.topsellingColumns');     
                    newreleaseColumns.splice(3, 1);
                    topsellingColumns.splice(3, 1);
                    cmp.set('v.newreleaseColumns',newreleaseColumns);
                    cmp.set('v.topsellingColumns', topsellingColumns);   
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getTranslations : function(cmp, event, helper){
        
        debugger
        var locale = $A.get("$Locale.language");
        var action = cmp.get("c.getTranslations");
        action.setParams({ langCode : locale});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var data =  response.getReturnValue();
                var nr = cmp.get('v.newrelease');
                var tp =cmp.get('v.topselling');
                var ns =cmp.get('v.newstock');
                var viewAll = cmp.get("v.ViewAll");
                viewAll = data[viewAll]
                nr=data[nr]
                tp=data[tp]
                ns= data[ns]
                cmp.set('v.newrelease',nr);
                cmp.set('v.topselling',tp);
                cmp.set('v.newstock',ns);
                
                var newrelease = cmp.find("newrelease").get("v.label");
                var topselling = cmp.find("topselling").get("v.label");
                var newstock = cmp.find("newstock").get("v.label");
                
                
                
                newrelease[0].set("v.value", nr);
                topselling[0].set("v.value", tp);
                newstock[0].set("v.value", ns);
                
                cmp.set("v.ViewAll",viewAll);
                helper.getColumns(cmp, event, helper,data);
                
            }
        });
        $A.enqueueAction(action);
    }
})