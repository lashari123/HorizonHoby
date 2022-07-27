public class OrderController {
    
    @AuraEnabled(cacheable=false)
    public static List<Order> getAllOrders(){
        return  [select id, tolabel(Status), PoNumber , OrderNumber, EffectiveDate, OwnerId, Name, Total_Quantity__c from Order where OwnerId =: Userinfo.getUserid() and Status ='Draft' order by OrderNumber desc];
    }
    
    public static List<Order> getAllOrders(integer limitTo){
        return  [select id, tolabel(Status), PoNumber , OrderNumber, EffectiveDate, OwnerId from Order where OwnerId =: Userinfo.getUserid() and Status ='Draft' limit :limitTo];
    }
    
    public static Order getOrderByID(string oid){
        return  [SELECT Id, Pricebook2Id, OriginalOrderId, EffectiveDate, EndDate, IsReductionOrder, tolabel(Status), Description, CustomerAuthorizedById, CompanyAuthorizedById, Type, AccountId ,OwnerId, ContractId, Name, PoDate, PoNumber, StatusCode, OrderNumber, TotalAmount, Order_Contact__c, Total_Quantity__c, Total_Discount__c FROM Order where id = :oid LIMIT 1];
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<Order> getAllActivatedOrders(){
        return  [select id, tolabel(Status), PoNumber , OrderNumber,OrderedDate, EffectiveDate, OwnerId from Order where OwnerId =: Userinfo.getUserid() and Status ='Activated'];
    }
    
    public static List<Order> getAllActivatedOrders(integer limitTo){
        return  [select id, tolabel(Status), PoNumber , OrderNumber,OrderedDate, EffectiveDate, OwnerId from Order where OwnerId =: Userinfo.getUserid() and Status ='Activated' limit :limitTo];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Order> getAllSubmittedOrders(){
        return  [select id, tolabel(Status), PoNumber , OrderNumber,OrderedDate, EffectiveDate, OwnerId from Order where OwnerId =: Userinfo.getUserid() and Status ='Submitted'];
    }
    public static List<Order> getAllSubmittedOrders(integer limitTo){
        return  [select id, tolabel(Status), PoNumber , OrderNumber,OrderedDate, EffectiveDate, OwnerId from Order where OwnerId =: Userinfo.getUserid() and Status ='Submitted' limit :limitTo];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Order> getAllCompletedOrders(){
        return  [select id, tolabel(Status), PoNumber , OrderNumber,OrderedDate, EffectiveDate, OwnerId from Order where OwnerId =: Userinfo.getUserid() and Status ='Completed'];
    }
    @AuraEnabled(cacheable=true)
    public static List<Order> getAllCompletedOrders(integer limitTo){
        return  [select id, tolabel(Status), PoNumber , OrderNumber,OrderedDate, EffectiveDate, OwnerId from Order where OwnerId =: Userinfo.getUserid() and Status ='Completed' limit :limitTo];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<OrderItem> getAllBackedOrders(){
        //   list<order> Orders =  [select id, tolabel(Status), PoNumber , OrderNumber,OrderedDate, EffectiveDate, OwnerId 
        //                         from Order where OwnerId =: Userinfo.getUserid() and Status ='Backed Order'];
        return [select id,tolabel(Product2.Name), Product2Id,Quantity,order.PONumber, order.OrderNumber,order.EffectiveDate from OrderItem  where status__c = 'BackOrder'];
    }
    
    public static List<OrderItem> getAllBackedOrders(integer limitTo){
        //  list<order> Orders =  [select id, tolabel(Status), PoNumber , OrderNumber,OrderedDate, EffectiveDate, OwnerId 
        //                         from Order where OwnerId =: Userinfo.getUserid() and Status ='Backed Order'];
        return [select id,tolabel(Product2.Name), Product2Id,Quantity,order.PONumber, order.OrderNumber,order.EffectiveDate from OrderItem  where status__c = 'BackOrder' limit :limitTo];
    }
    
    public static void UpdateOrderName(String Name, String oid){
        Order o = new Order();
        o.Name = Name;
        o.Id = oid;
        
        update o;
        
    }
    
    
    @AuraEnabled
    public static void addOrderItem(String skuQuantityListString, String orderId){
        List<String> quickOrderParam = new List<String>();
        Type ArrType = Type.forName('List<string>');
        List<string> skuQuantities = (List<string>) JSON.deserialize(skuQuantityListString, ArrType);
        List<OrderItem> orderProducts = new List<OrderItem>();
        List<Order> orders = new List<Order>();
        String Pricebook2Id;
        
        orders = [select id, OrderNumber, Pricebook2Id from Order where id =: orderId];
        if(orders.size()>0){
            if(orders[0].Pricebook2Id != null){
                Pricebook2Id = orders[0].Pricebook2Id;
            } else{
                Pricebook2Id = 'Update';
            }
        }
        
        for(String skuQuantity : skuQuantities){
            quickOrderParam = skuQuantity.split('_');
            String sku = quickOrderParam[0];
            Integer quantity = Integer.valueOf(quickOrderParam[1]);
            
            system.debug('sku:::' + sku);
            system.debug('quantity:::' + quantity);
            List<PricebookEntry> pricebookEntry = new List<PricebookEntry>();
            
            
            if(Pricebook2Id != 'Update'){
                pricebookEntry = [select id, Product2Id, Product2.IsActive, Product2.StockKeepingUnit, IsActive, UnitPrice, Pricebook2Id from PricebookEntry where pricebook2.name ='Dealer Price Book' and IsActive = true and Product2.IsActive = true and Product2.ProductCode =: sku and Pricebook2Id =: Pricebook2Id  ORDER BY UnitPrice ASC LIMIT 1];                
            } else{
                pricebookEntry = [select id, Product2Id, Product2.IsActive, Product2.StockKeepingUnit, IsActive, UnitPrice, Pricebook2Id from PricebookEntry where pricebook2.name ='Dealer Price Book' and IsActive = true and Product2.IsActive = true and Product2.ProductCode =: sku ORDER BY UnitPrice ASC LIMIT 1];                                
            }
            if(pricebookEntry.size()>0){
                
                if(Pricebook2Id == 'Update'){
                    orders[0].Pricebook2Id = pricebookEntry[0].Pricebook2Id;
                    update orders[0];
                }
                
                OrderItem orderProduct = new OrderItem();
                orderProduct.OrderId = orderId;
                orderProduct.PricebookEntryId = pricebookEntry[0].id;
                orderProduct.Product2Id = pricebookEntry[0].Product2Id;
                orderProduct.Quantity = quantity;
                orderProduct.UnitPrice = pricebookEntry[0].UnitPrice;
                orderProduct.TotalLineAmount = orderProduct.Quantity * orderProduct.UnitPrice;
                orderProducts.add(orderProduct);
                
            }
        }
        //update orders[0];
        insert orderProducts;
    }
    
    @AuraEnabled
    public static String addToNewOrder(String skuQuantityListString){
        system.debug(UserInfo.getUserId());
        List<String> quickOrderParam = new List<String>();
        Type ArrType = Type.forName('List<string>');
        List<string> skuQuantities = (List<string>) JSON.deserialize(skuQuantityListString, ArrType);
        List<OrderItem> orderProducts = new List<OrderItem>();
        List<Order> orders = new List<Order>();
        String Pricebook2Id = 'Update';
        String contactId = [Select Id, contactid from User where Id =: Userinfo.getUserid()].contactid;
        system.debug(contactId); 
        String AccID  = [Select Id, AccountID from Contact where Id =: contactid].AccountId;
        system.debug(AccID);
        List<Order> newOrderList = new List<Order>();
        Order newOrder = new Order();
        newOrder.Status = 'Draft';
        newOrder.OwnerId = Userinfo.getUserid();
        newOrder.AccountId = AccID;
        newOrder.EffectiveDate = Date.today();
        newOrder.PoNumber = 'Test Account';
        newOrderList.add(newOrder);
        
        
        system.debug(':::' + skuQuantities.size());
        
        for(String skuQuantity : skuQuantities){
            quickOrderParam = skuQuantity.split('_');
            String sku = quickOrderParam[0];
            Integer quantity = Integer.valueOf(quickOrderParam[1]);
            system.debug('sku:::' + sku);
            system.debug('quantity:::' + quantity);
            List<PricebookEntry> pricebookEntry = new List<PricebookEntry>();
            
            
            if(Pricebook2Id != 'Update'){
                pricebookEntry = [select id, Product2Id, Product2.IsActive, Product2.StockKeepingUnit, IsActive, UnitPrice, Pricebook2Id from PricebookEntry where pricebook2.name ='Dealer Price Book' and IsActive = true and Product2.IsActive = true and Product2.ProductCode =: sku and Pricebook2Id =: Pricebook2Id  ORDER BY UnitPrice ASC LIMIT 1];                
            } else{
                pricebookEntry = [select id, Product2Id, Product2.IsActive, Product2.StockKeepingUnit, IsActive, UnitPrice, Pricebook2Id from PricebookEntry where pricebook2.name ='Dealer Price Book' and IsActive = true and Product2.IsActive = true and Product2.ProductCode =: sku ORDER BY UnitPrice ASC LIMIT 1];                                
            }
            if(pricebookEntry.size()>0){
                
                if(Pricebook2Id == 'Update'){
                    newOrderList[0].Pricebook2Id = pricebookEntry[0].Pricebook2Id;
                    Pricebook2Id = pricebookEntry[0].Pricebook2Id;
                    insert newOrderList;
                }
                
                OrderItem orderProduct = new OrderItem();
                orderProduct.OrderId = newOrder.Id;
                orderProduct.PricebookEntryId = pricebookEntry[0].id;
                orderProduct.Product2Id = pricebookEntry[0].Product2Id;
                orderProduct.Quantity = quantity;
                orderProduct.UnitPrice = pricebookEntry[0].UnitPrice;
                orderProduct.TotalLineAmount = orderProduct.Quantity * orderProduct.UnitPrice;
                orderProducts.add(orderProduct);
                
            }
        }
        system.debug('orderProducts.size():::' + orderProducts.size());
        //update orders[0];
        insert orderProducts;
        /*Order returnOrder = new Order();
returnOrder.id = newOrder.Id;
returnOrder.Status = newOrder.Status;
returnOrder.PoNumber = newOrder.PoNumber;
returnOrder.OrderNumber = newOrder.OrderNumber;
returnOrder.EffectiveDate = newOrder.EffectiveDate;
returnOrder.OwnerId = newOrder.OwnerId;*/
        Order returnOrder = [SELECT id, OrderNumber FROM Order where id =:newOrderList[0].Id];
        //return newOrderList[0].Id;
        return returnOrder.Id;
    }
    
    @AuraEnabled
    public static OrderItem[] orderItemsbyOrderId(String orderID){
        system.debug(orderID);
        OrderItem[] items = [SELECT Id, Product2Id,Product2.name,opened__c,fulfilled__c,cancelled__c,description,product2.PrimaryImageID__c,Product2.ProductCode ,product2.avail__c,product2.weight__c, OrderId,Order.orderNumber,Order.Name,order.poNumber,order.endDate, 
                             PricebookEntryId, OriginalOrderItemId, Quantity, AvailableQuantity, UnitPrice, 
                             TotalPrice, ListPrice, TotalLineAmount, Status__c, OrderItemNumber ,product2.isBackorderDuplicate__c,
                             product2.isHazardousItems__c,product2.isItemOnBackorder__c,product2.isMaxQuantities__c,
                             product2.isPartAvailable__c,product2.isSalesMultiple__c,product2.isSmartTechnology__c 
                             FROM OrderItem WHERE OrderID = :orderID];
        
        return items;
        
    }
    class AlertGroupWrapper{
        public AlertGroupWrapper(string Name,string icon){
            alertName = Name;
            iconName = icon;
            items = new list<OrderItem>();
        }
        public string alertName {get;set;}
        public list<OrderItem> items {get;set;}
        
        public string iconName {get;set;}
    }
    @AuraEnabled
    public static string orderLineItemsGroupByAlerts(String orderID){
        
        system.debug(orderID);
        OrderItem[] items = [SELECT Id, Product2Id,Product2.name,description,product2.PrimaryImageID__c,Product2.ProductCode ,product2.avail__c,product2.weight__c, OrderId,Order.orderNumber,Order.Name,order.poNumber,order.endDate, 
                             PricebookEntryId, OriginalOrderItemId, Quantity, AvailableQuantity, UnitPrice, 
                             TotalPrice, ListPrice, TotalLineAmount, Status__c, OrderItemNumber,product2.isBackorderDuplicate__c,
                             product2.isHazardousItems__c,product2.isItemOnBackorder__c,product2.isMaxQuantities__c,
                             product2.isPartAvailable__c,product2.isSalesMultiple__c,product2.isSmartTechnology__c 
                             FROM OrderItem WHERE OrderID = :orderID];
        
        AlertGroupWrapper hazard = new AlertGroupWrapper('Hazardous Items','hh_order_icon01');
        AlertGroupWrapper maxQuantities = new AlertGroupWrapper('Max Quantities','hh_order_icon02');
        AlertGroupWrapper salesmulti = new AlertGroupWrapper('Sales Multiple','hh_order_icon03');
        AlertGroupWrapper backorderDup = new AlertGroupWrapper('Backorder Duplicate','hh_order_icon04');
        AlertGroupWrapper backorder = new AlertGroupWrapper('Item on Backorder','hh_order_icon05');
        AlertGroupWrapper partAvail = new AlertGroupWrapper('Parts Available','hh_order_icon06');
        AlertGroupWrapper smartTech = new AlertGroupWrapper('Smart Technology','hh_order_icon07');
        
        for(orderItem item:items){
            if(item.product2.isBackorderDuplicate__c == true){
                backorderDup.items.add(item);
            }
            if(item.product2.isHazardousItems__c == true){
                hazard.items.add(item);
            }
            if(item.product2.isItemOnBackorder__c == true){
                backorder.items.add(item);
            }
            if(item.product2.isMaxQuantities__c == true){
                maxQuantities.items.add(item);
            }
            if(item.product2.isPartAvailable__c == true){
                partAvail.items.add(item);
            }
            if(item.product2.isSalesMultiple__c == true){
                salesmulti.items.add(item);
            }
            if(item.product2.isSmartTechnology__c == true){
                smartTech.items.add(item);
            }
        }
        list<AlertGroupWrapper> listOfAlerts = new  list<AlertGroupWrapper>();
        
        listOfAlerts.add(backorderDup);
        listOfAlerts.add(hazard);
        listOfAlerts.add(maxQuantities);
        listOfAlerts.add(backorder);
        listOfAlerts.add(partAvail);
        listOfAlerts.add(salesmulti);
        listOfAlerts.add(smartTech);
        
        return JSON.serialize(listOfAlerts);
        
    }
    
    
    @AuraEnabled
    public static ShoppingCartDetailsWrapper orderItemsDetailslCheckout(String orderID){
        ShoppingCartDetailsWrapper cartWrap = new ShoppingCartDetailsWrapper();
        List<Order> orderList = new List<Order>();
        List<B2B_Configuration__mdt> config = new List<B2B_Configuration__mdt>();
        List<Contact> con = new List<Contact>();
        List<Account> acc = new List<Account>();
        
        config =  [SELECT Id, Label, Shipping_Fee__c, Shipping_Threshold__c FROM B2B_Configuration__mdt WHERE Label = 'B2B Configuration Record'];
        orderList = [SELECT Id, status,TotalAmount,endDate, TotalTaxAmount, TotalAdjustedDeliveryAmount, Total_Discount__c, Name, poNumber, orderNumber, Description FROM Order WHERE Id =: orderID];
        
        String contactId = [Select Id, contactid from User where Id =: Userinfo.getUserid()].contactid;
        con  = [Select Id, AccountID, Name, Email, Account_Shipping_Address__c from Contact where Id =: contactid];
        acc = [SELECT Id, BillingCountry,ShippingCountry,ShippingAddress, Shipping_Type__c, Payment_Type__c FROM Account WHERE Id =: con[0].AccountId];
        
        if(orderList.size()>0 && config.size()>0){
            
            
            Tax__c taxInfo = [SELECT id,VAT__c from tax__c where country__c =:acc[0].ShippingCountry limit 1];
            system.debug(taxInfo.Vat__C);
            
            Decimal discount = orderList[0].Total_Discount__c != null ? orderList[0].Total_Discount__c : 0;
            Decimal Tax = orderList[0].TotalAmount * (taxInfo.Vat__c/100);//orderList[0].TotalTaxAmount != null ? orderList[0].TotalTaxAmount : 0;
            
            Decimal totalAmountBeforeShipping = orderList[0].TotalAmount + Tax - discount;
            Boolean isShipping = totalAmountBeforeShipping < config[0].Shipping_Threshold__c ? true : false;
            if(isShipping){
                //cartWrap.shipping = orderList[0].TotalAdjustedDeliveryAmount != null ? orderList[0].TotalAdjustedDeliveryAmount : 50;
                cartWrap.shipping = config[0].Shipping_Fee__c;
                cartWrap.awayFromFreeShipping = config[0].Shipping_Threshold__c - totalAmountBeforeShipping;
                cartWrap.FreeShippingPercent = (totalAmountBeforeShipping/config[0].Shipping_Threshold__c) * 100; 
            } else{
                cartWrap.shipping = 0;
                cartWrap.FreeShippingPercent = 100;
                cartWrap.awayFromFreeShipping = 0;
            }
            
            // Decimal shipping = orderList[0].TotalAdjustedDeliveryAmount != null &&  ? orderList[0].TotalAdjustedDeliveryAmount : 0;
            cartWrap.orderOriginalPrice = orderList[0].TotalAmount;
            cartWrap.orderDiscount = discount;           
            cartWrap.salesTaxVAT = Tax;
            Decimal total =  totalAmountBeforeShipping + cartWrap.shipping;
            cartWrap.orderNetTotal = total;
        }
        
        if(orderList.size()>0){
            cartWrap.Name = orderList[0].Name != null ? orderList[0].Name : '';
            cartWrap.PONumber = orderList[0].poNumber;
            cartWrap.Status = orderList[0].status;
            cartWrap.OrderName = orderList[0].orderNumber;
            cartWrap.EndDate = orderList[0].enddate;
            cartWrap.Description = orderList[0].Description != null ? orderList[0].Description : orderList[0].Description;
        }
        cartWrap.contactName = con[0].Name != null ? con[0].Name : '';
        cartWrap.email = con[0].Email != null ? con[0].Email : '';
        cartWrap.shippingAddress = con[0].Account_Shipping_Address__c != null ? con[0].Account_Shipping_Address__c : '';
        cartWrap.shippingType = acc[0].Shipping_Type__c != null ? acc[0].Shipping_Type__c : '';
        cartWrap.paymentType = acc[0].Payment_Type__c != null ? acc[0].Payment_Type__c : '';
        
        return cartWrap;
    }   
    @AuraEnabled
    public static ShoppingCartDetailsWrapper orderItemsDetailslbyOrderId(String orderID,string userId){
        
        
        OrderItem[] items = [SELECT Id, Product2Id,product2.avail__c,product2.weight__c, OrderId,order.status,Order.orderNumber,Order.Name,order.description,order.poNumber,order.endDate, 
                             PricebookEntryId, OriginalOrderItemId, Quantity, AvailableQuantity, UnitPrice, 
                             TotalPrice, ListPrice, TotalLineAmount, Status__c, OrderItemNumber,product2.isBackorderDuplicate__c,
                             product2.isHazardousItems__c,product2.isItemOnBackorder__c,product2.isMaxQuantities__c,
                             product2.isPartAvailable__c,product2.isSalesMultiple__c,product2.isSmartTechnology__c 
                             FROM OrderItem WHERE OrderID = :orderID];
        if(items.size() == 0){
            return null;
        }
        system.debug(items);
        AggregateResult[] totalSumOfItems = [SELECT sum(TotalLineAmount)Total FROM OrderItem WHERE OrderID = :orderID];
        system.debug(totalSumOfItems);
        AggregateResult[] totalQuantity = [SELECT sum(quantity)Total FROM OrderItem WHERE OrderID = :orderID];
        system.debug(totalSumOfItems);
        AggregateResult[] totalShipableSumOfItems = [SELECT sum(TotalLineAmount)Total FROM OrderItem WHERE OrderID = :orderID and product2.avail__C = 'y'];
        
        AggregateResult[] totalShippedSumOfItems = [SELECT sum(fulfilled__c)Total FROM OrderItem WHERE OrderID = :orderID and product2.avail__C = 'y'];
        
        AggregateResult[] totalOpenedSumOfItems = [SELECT sum(opened__c)Total FROM OrderItem WHERE OrderID = :orderID and product2.avail__C = 'y'];
        
        AggregateResult[] totalCancelledSumOfItems = [SELECT sum(Cancelled__c)Total FROM OrderItem WHERE OrderID = :orderID and product2.avail__C = 'y'];
        
        AggregateResult[] estimatedweight = [SELECT sum(Estimated_Weight__c)Total FROM OrderItem WHERE OrderID = :orderID and product2.avail__C = 'y'];
        
        AggregateResult[] estimatedcube = [SELECT sum(Estimated_Cube__c)Total FROM OrderItem WHERE OrderID = :orderID and product2.avail__C = 'y'];
        
        ShoppingCartDetailsWrapper cartWrap = new ShoppingCartDetailsWrapper();
        cartWrap.lines = items.size();
        cartWrap.EstTotal = (double) totalSumOfItems[0].get('total');
        cartWrap.EstShipable = (double)totalShippedSumOfItems[0].get('total');
        cartWrap.EstOpened = (double)totalOpenedSumOfItems[0].get('total');
        cartWrap.EstCancelled = (double)totalCancelledSumOfItems[0].get('total');
        cartWrap.EstWeight = (double)estimatedweight[0].get('total');
        cartWrap.OrderName = items[0].Order.orderNumber;
        cartWrap.TotalItems = (double)totalQuantity[0].get('total');
        cartWrap.Name = items[0].Order.Name;
        cartWrap.PONumber = items[0].order.poNumber;
        cartWrap.description=items[0].order.description;
        cartWrap.EndDate = items[0].order.EndDate;
        
        cartWrap.EstCube = (double)estimatedcube[0].get('total');
        /*
Order ord = [select Id, SFCC_Order_Total__c from Order where Id = :orderID];

//need to review undelying fields
//cartWrap.orderOriginalPrice = (double)totalShipableSumOfItems[0].get('total');
cartWrap.orderOriginalPrice = ord.SFCC_Order_Total__c;
cartWrap.orderDiscount = 0;
cartWrap.shipping = 6;
cartWrap.salesTaxVAT = 0;*/
        //************************ Code Copied from checkout**********************//
        List<Order> orderList = new List<Order>();
        List<B2B_Configuration__mdt> config = new List<B2B_Configuration__mdt>();
        
        config =  [SELECT Id, Label, Shipping_Fee__c, Shipping_Threshold__c FROM B2B_Configuration__mdt WHERE Label = 'B2B Configuration Record'];
        orderList = [SELECT Id, tolabel(status),TotalAmount, TotalTaxAmount, TotalAdjustedDeliveryAmount, Total_Discount__c FROM Order WHERE Id =: orderID];
        
        User u = [SELECT Name, AccountId,Account.ShippingCountry, Account.StoreName__c FROM User WHERE Id = :userId limit 1];
        
        
        
        Tax__c taxInfo = [SELECT id,VAT__c from tax__c where country__c = :u.Account.ShippingCountry limit 1];
        system.debug(taxInfo.Vat__C);
        
        cartWrap.storeName = u.Account.StoreName__c;
        
        if(orderList.size()>0 && config.size()>0){
            Decimal discount = orderList[0].Total_Discount__c != null ? orderList[0].Total_Discount__c : 0;
            Decimal Tax = orderList[0].TotalAmount * (taxInfo.Vat__c/100);//orderList[0].TotalTaxAmount != null ? orderList[0].TotalTaxAmount : 0;
            Decimal totalAmountBeforeShipping = orderList[0].TotalAmount + Tax - discount;
            Boolean isShipping = totalAmountBeforeShipping < config[0].Shipping_Threshold__c ? true : false;
            if(isShipping){
                //cartWrap.shipping = orderList[0].TotalAdjustedDeliveryAmount != null ? orderList[0].TotalAdjustedDeliveryAmount : 50;
                cartWrap.shipping = config[0].Shipping_Fee__c;
                cartWrap.awayFromFreeShipping = config[0].Shipping_Threshold__c - totalAmountBeforeShipping;
                cartWrap.FreeShippingPercent = (totalAmountBeforeShipping/config[0].Shipping_Threshold__c) * 100; 
            } else{
                cartWrap.shipping = 0;
                cartWrap.FreeShippingPercent = 100;
                cartWrap.awayFromFreeShipping = 0;
            }
            
            // Decimal shipping = orderList[0].TotalAdjustedDeliveryAmount != null &&  ? orderList[0].TotalAdjustedDeliveryAmount : 0;
            cartWrap.orderOriginalPrice = orderList[0].TotalAmount;
            cartWrap.status = orderList[0].status;
            
            cartWrap.orderDiscount = discount;           
            cartWrap.salesTaxVAT = Tax;
            Decimal total =  totalAmountBeforeShipping + cartWrap.shipping;
            cartWrap.orderNetTotal = total;
        }
        //******************************copied code end*******************************//
        /* cartWrap.orderNetTotal = (cartWrap.orderOriginalPrice + cartWrap.shipping + cartWrap.salesTaxVAT) - cartWrap.orderDiscount ;

if ((((cartWrap.orderOriginalPrice- cartWrap.orderDiscount + cartWrap.salesTaxVAT ) / 500) * 100) >= 100)
{
cartWrap.awayFromFreeShipping = 100;
}
else
{
cartWrap.awayFromFreeShipping = ((cartWrap.orderOriginalPrice- cartWrap.orderDiscount + cartWrap.salesTaxVAT ) / 500) * 100;
}*/
        String contactId = [Select Id, contactid from User where Id =: Userinfo.getUserid()].contactid;
        contact[] con  = [Select Id, AccountID, Name, Email, Account_Shipping_Address__c from Contact where Id =: contactid];
        account[] acc = [SELECT Id, BillingCountry,ShippingCountry,ShippingAddress, Shipping_Type__c, Payment_Type__c FROM Account WHERE Id =: con[0].AccountId];
        
        cartWrap.contactName = con[0].Name != null ? con[0].Name : '';
        cartWrap.email = con[0].Email != null ? con[0].Email : '';
        cartWrap.shippingAddress = con[0].Account_Shipping_Address__c != null ? con[0].Account_Shipping_Address__c : '';
        cartWrap.shippingType = acc[0].Shipping_Type__c != null ? acc[0].Shipping_Type__c : '';
        cartWrap.paymentType = acc[0].Payment_Type__c != null ? acc[0].Payment_Type__c : '';
        
        
        system.debug(cartWrap);
        return cartWrap;
        
        
        
    }
    public Class ShoppingCartDetailsWrapper{
        public integer lines  {get;set;}
        public double EstTotal {get;set;}
        public double EstShipable {get;set;}
        public double EstCancelled {get;set;}
        public double EstOpened {get;set;}
        public double EstWeight {get;set;}
        public double EstCube {get;set;}
        public double selectedLinesTotal {get;set;}
        public string OrderName {get;set;}
        public string Status {get;set;}
        public string PONumber {get;set;}
        public string Description {get;set;}
        public Date EndDate {get;set;}
        public string Name {get;set;}
        public double TotalItems  {get;set;}
        public double orderOriginalPrice  {get;set;}
        public double orderDiscount  {get;set;}
        public double shipping  {get;set;}
        public double salesTaxVAT  {get;set;}
        public double orderNetTotal  {get;set;}        
        public double awayFromFreeShipping  {get;set;} 
        public double FreeShippingPercent  {get;set;} 
        public string contactName {get;set;}
        public string email {get;set;}
        public String shippingAddress {get;set;}
        public String shippingType {get;set;}
        public String paymentType {get;set;}
        public String storeName {get;set;}
        
        
    } 
    
    public static string AllOrder(){
        
            order[] orders = [SELECT Id, Status, EndDate, EffectiveDate, Description, Type, CreatedDAte, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude, BillingGeocodeAccuracy, BillingAddress, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingLatitude, ShippingLongitude, ShippingGeocodeAccuracy, ShippingAddress, PoDate, Name, PoNumber, StatusCode, OrderNumber, TotalAmount, Total_Discount__c, Total_Quantity__c, Order_Line_Items_Count__c FROM Order where OwnerId =: Userinfo.getUserid()  order by OrderNumber desc ];
        	return JSON.serialize(orders);
        
       
    }
    public static string AllBackedOrder(){
        
        	OrderItem[] orders = [SELECT Id, Order.OrderNumber, opened__c, Order.poNumber, Product2.Description, Product2.avail__c, Order.EndDate, Product2.ProductCode, UnitPrice, TotalPrice, Order.CreatedDate FROM OrderItem where /*Order.OwnerId =: Userinfo.getUserid() AND*/ Status__c ='BackOrder'];
        	return JSON.serialize(orders);
        
      
    }
    
}