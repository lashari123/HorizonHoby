({
    generateCSVData : function(cmp,event,helper){
        debugger
        var data =  cmp.get("v.data");
        var calledFrom = cmp.get("v.calledFrom");
        console.log(calledFrom);
        var csvData = [];
        if(calledFrom == 'orderDetail'){
            data.forEach(function(item)
                         {
                             var a  = {};
                             a.Item = item.ProductCode;
                             a.QTY = item.Quantity;
                             a.Description = item.Name;
                             a.UnitPrice = item.UnitPrice;
                             a.Total = item.TotalPrice;
                             a.BO = 'Y';
                             a.Opened = item.TotalAmount;
                             a.Fulfilled = item.TotalAmount;
                             a.Cancelled = item.TotalAmount;
                             a.Note = item.Name;
                             a.Invoice = 0;
                            csvData.push(a);                         
                         });
            
        } else if(item.pbe.Product2 == undefined){
            data.forEach(function(item)
                         {
                             var a  = {};
                             a.OrderDate = item.EffectiveDate;
                             a.OrderNo = item.OrderNumber;
                             a.PONo = item.PoNumber;
                             a.TotalLines = item.Order_Line_Items_Count__c;
                             a.TotalValue = item.TotalAmount;
                             a.ShippedValue = item.TotalAmount;
                             a.RemainingValue = TotalAmount;
                             a.Cancelled = TotalAmount;
                             a.PreferedShipDate = item.EffectiveDate;
                             a.Status = item.Status;
                             a.Invoice = 0;
                            csvData.push(a);                         
                         });
        }
        else{
        data.forEach(function(item)
                     {
                         var a  = {};
                         a.Item = item.pbe.Product2.ProductCode;
                         a.Description = item.ProductName;
                         a.Retail = item.retail;
                         a.Dealer = item.dealer;
                         a.Avail = item.pbe.Product2.Avail__c;
                         a.ETA = item.pbe.Product2.ETA__c;
                         a.shipCode = item.pbe.Product2.ShippingClass__c;
                         a.Category = item.Category;
                         a.InventoryStatus = item.pbe.Product2.InventoryStatus__c;
                         a.UPC = item.item.pbe.Product2.UPC__c;
                         a.LastUpdated = item.item.pbe.Product2.LastUpdated__c;
                         a.Rank = item.item.pbe.Product2.Rank__c;
                         csvData.push(a);                         
                     });
        }
        csv.Data.Push('')
       
        
        csv.Data.Push('Please do not share any data or content from this partner site outside of your organization.')
        csv.Data.Push('Product pricing is valid as of the time of printing 20-11-2021 and subject to change at the discretion of Horizon Hobby.')
        cmp.set("v.csvData", csvData);
    },
    convertListToCSV : function(component, sObjectList){
        
        var data =  sObjectList
        var csvData = [];
        var orderName = '';
        var orderNum = '';
        var calledFrom = component.get("v.calledFrom");
        console.log(calledFrom);
        console.log(':::' + JSON.stringify(data[0]));
         if(calledFrom == 'orderDetail'){
            data.forEach(function(item)
                         {
                             var a  = {};
                             a.Item = item.Product2.ProductCode;
                             a.QTY = item.Quantity;
                             a.Description = item.Description;
                             a.UnitPrice = item.UnitPrice;
                             a.Total = item.TotalPrice;
                             a.BO = 'Y';
                             a.Note = item.Product2.Name;
                            csvData.push(a); 
                           //  orderName = item.Order.Name;
                             orderNum = item.Order.OrderNumber;
                         });
            
        } else if(calledFrom == 'backOrders'){
            data.forEach(function(item)
                         {
                             var a  = {};
                             a.OrderNo = item.Order.OrderNumber;
                             a.ItemNo = item.Product2.ProductCode;
                             a.PONo = item.Order.PoNumber;
                             a.Description = item.Product2.Description;
                             a.OpenQty = item.opened__c;
                             a.Availability = item.Product2.avail__c;
                             a.UnitPrice = item.UnitPrice;
                             a.TotalPrice = item.TotalPrice;
                             a.OrderDate = item.Order.CreatedDate;
                             a.PreferedShipDate = item.Order.EndDate;
                             
                            csvData.push(a);                         
                         });
            
        } else if(data[0].pbe == undefined){
            
            data.forEach(function(item)
                         {
                             var a  = {};
                             a.OrderDate = item.EffectiveDate;
                             a.OrderNo = item.OrderNumber;
                             a.PONo = item.PoNumber;
                             a.TotalLines = item.Order_Line_Items_Count__c;
                             a.TotalValue = item.TotalAmount;
                             a.ShippedValue = item.TotalAmount;
                             a.RemainingValue = item.TotalAmount;
                             a.Cancelled = item.TotalAmount;
                             a.PreferedShipDate = item.EffectiveDate;
                             a.Status = item.Status;
                             a.Invoice = 0;
                            csvData.push(a);                         
                         });
        }
        else{
        data.forEach(function(item)
                     {
                         var a  = {};
                         a.Item = item.pbe.Product2.ProductCode;
                         a.Description = item.ProductName;
                         a.Retail = item.retail;
                         a.Dealer = item.dealer;
                         a.Avail = item.pbe.Product2.Avail__c;
                         a.ETA = item.pbe.Product2.ETA__c;
                         a.shipCode = item.pbe.Product2.ShippingClass__c;
                         a.Category = item.category;
                         a.InventoryStatus = item.pbe.Product2.InventoryStatus__c;
                         a.UPC = item.pbe.Product2.UPC__c;
                         a.LastUpdated = item.pbe.Product2.LastUpdated__c;
                         a.Rank = item.pbe.Product2.Rank__c;
                         csvData.push(a);                         
                     });
        }
        sObjectList = csvData
        
        if (sObjectList == null || sObjectList.length == 0) {
            return null; // 
        }
        
        // CSV file parameters.
        var columnEnd = ',';
        var lineEnd =  '\n';
        
        // Get the CSV header from the list.
        var keys = new Set();
        sObjectList.forEach(function (record) {
            Object.keys(record).forEach(function (key) {
                keys.add(key);
            });
        });
        
        // 
        keys = Array.from(keys);
        
        var csvString = '';
        if(calledFrom == 'orderDetail'){
            csvString+= 'DRAFT ORDER--' + orderName + ' | ' + orderNum;
        }
        
        csvString += lineEnd;
        csvString += keys.join(columnEnd);
        csvString += lineEnd;
        
        for(var i=0; i < sObjectList.length; i++){
            var counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;
                
                // add , after every value except the first.
                if(counter > 0){
                    csvString += columnEnd;
                }
                
                // If the column is undefined, leave it as blank in the CSV file.
                var value = sObjectList[i][skey] === undefined ? '' : sObjectList[i][skey];
                csvString += '"'+ value +'"';
                counter++;
            }
            
            csvString += lineEnd;
        }
        csvString += lineEnd;
        csvString+= 'Please do not share any data or content from this partner site outside of your organization.'
        csvString += lineEnd;
        var today = $A.localizationService.formatDate(new Date(), "DD-MM-YYYY");
        csvString += 'Product pricing is valid as of the time of printing '+today+' and subject to change at the discretion of Horizon Hobby.'
        csvString += lineEnd;
        
        return csvString;
    },
})