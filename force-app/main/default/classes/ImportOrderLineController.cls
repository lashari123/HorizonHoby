public class ImportOrderLineController {
    
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public List<account> acclist{get;set;}
    
    public Map<string,string> validateResult {get;set;}
    public integer successTotal {get;set;}
    public integer failedTotal {get;set;}
    public List<string> skuList1 {get;set;}
     
    public ImportOrderLineController(){
        csvFileLines = new String[]{};
            acclist = New List<Account>(); 
    }
    
    public void fetchData()
    {
        string currentRecordId = ApexPages.CurrentPage().getparameters().get('Id'); 
        
        Map<string,string> validatefile=  ImportOrderLineController.validateFile(currentRecordId);
        List<string> skuList= new List<string>(validatefile.keySet());
        skuList1=skuList;
        
        validateResult=validatefile;
        Integer success=0;
        Integer failed=0;
      
        for(string result: validatefile.values()){
            if(result=='Found'){
                success=success+1;
            }else{
                failed=failed+1;
            }
        }
        successTotal=success;
        failedTotal=failed;
    }
    
    
    @AuraEnabled(cacheable=false)
    public static List<Order> getAllOrders(){
        return  [select id, tolabel(Status), PoNumber , OrderNumber, EffectiveDate, OwnerId, Name, Total_Quantity__c from Order where OwnerId =: Userinfo.getUserid() and Status ='Draft' order by OrderNumber desc];
    }
  
        
    @AuraEnabled 
    public static string deleteContentDocument(string recordId){
        //List<ContentDocumentLink> cdl=[Select Id,ContentDocumentId,ContentDocument.Title,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:recordId order by Id desc limit 1];
       //delete cdl[0];
        
        try{
            delete [Select Id,ContentDocumentId,ContentDocument.Title,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:recordId order by Id desc limit 1];
            return 'SUCCESS';
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        } 
       
    }
    @AuraEnabled 
    public static User getUserInfo(){
        User u = [Select Id,Name,ContactId,Email from User where Id=:userinfo.getUserId()];
        
        return u;
    }

    @AuraEnabled
    public static String addToNewOrder(){
        
        String Pricebook2Id = 'Update';
        String contactId = [Select Id, contactid from User where Id =: Userinfo.getUserid()].contactid;
        system.debug(contactId); 
        String AccID  = [Select Id, AccountID from Contact where Id =: contactid].AccountId;
        system.debug(AccID);

        List<Pricebook2> pbook= [Select Id,Name from Pricebook2 where name='Dealer Price Book' limit 1];

      
        Order newOrder = new Order();
        newOrder.Status = 'Draft';
        newOrder.OwnerId = Userinfo.getUserid();
        newOrder.AccountId = AccID;
        newOrder.EffectiveDate = Date.today();
        newOrder.PoNumber = 'Test Account';
        if(pbook.size()>0){
            newOrder.Pricebook2Id=pbook[0].Id;}
 

        insert newOrder;
        Order returnOrder = [SELECT id, OrderNumber FROM Order where id =:newOrder.Id];
        //return newOrderList[0].Id;
        return returnOrder.Id;
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
    public static  Map<string, string> validateFile(String recordId){ 
        
        boolean isFileValid= true;
        Set<Id> recordIds = new Set<Id>{recordId};
            
            List<ContentDocumentLink> cdlList = [SELECT Id, LinkedEntityId, ContentDocumentId FROM 
                                                 ContentDocumentLink WHERE LinkedEntityId IN :recordIds
                                                 order by Id desc
                                                ];      
        
        List<ContentVersion> cvList = [Select Id, ContentDocumentId, VersionData,ContentModifiedDate  from ContentVersion where ContentDocumentId=: cdlList[0].ContentDocumentId order by ContentModifiedDate desc limit 1];
        
        Blob csvFileBody =cvList[0].VersionData;
        String csvAsString= csvFileBody.toString();
        List<String> csvFileLines= csvAsString.split('\n');
        system.debug(csvFileLines);
        
        Map<string,integer> productCodeWithQty = new Map<string,integer>();
        
        
        List<String> columnvalue  = new List<string>();
        for(Integer i=0; i<csvFileLines.size(); i++){
            string[] csvRecordData1 = csvFileLines[i].split(',');
            columnvalue.add(csvRecordData1[0]); // here 0 indicates the no. of column from which value you want to store 
            
            productCodeWithQty.put(csvRecordData1[0], Integer.valueOf(csvRecordData1[1].trim()) );
        }
        
        system.debug(columnValue);
        
        system.debug(productCodeWithQty);
        
        Map<string,boolean> productValidation= ImportOrderLineController.validateWithExistingProducts(productCodeWithQty.keyset());
        Map<string, string> productValidationComplete = new Map<string, string>();
        //fill complete map
        for(string prodCode : productCodeWithQty.keyset()){
            if(productValidation.containsKey(prodCode)){
                //if exist
                productValidationComplete.put(prodCode,'Accepted');
            }else{
                productValidationComplete.put(prodCode,'Failed');
                isFileValid =false;
            }
        }
        system.debug(productValidationComplete);
        
        return productValidationComplete;
        //return isFileValid;
        //return [SELECT Id, Title, FileType FROM ContentDocument WHERE Id IN :documentIds AND Title like: fileName]; 
    } 
    
    
    @AuraEnabled  
    public static string validateFilePDF(String recordId){ 

        PageReference pdf =  Page.importOrderLinePDF;
        
        pdf.getParameters().put('Id',recordId); 
        
        pdf.setRedirect(true);
        
        Blob b;
        b = pdf.getContent();

        return EncodingUtil.base64Encode(pdf.getContentAsPDF());
    } 
    
    
    @AuraEnabled  
    public static List<string> getCSVContent(String recordId){ 
        
        boolean isFileValid= true;
        Set<Id> recordIds = new Set<Id>{recordId};
            
            List<ContentDocumentLink> cdlList = [SELECT Id, LinkedEntityId, ContentDocumentId FROM 
                                                 ContentDocumentLink WHERE LinkedEntityId IN :recordIds
                                                 order by Id desc
                                                ];      
        
        List<ContentVersion> cvList = [Select Id, ContentDocumentId, VersionData,ContentModifiedDate  from ContentVersion where ContentDocumentId=: cdlList[0].ContentDocumentId order by ContentModifiedDate desc limit 1];
        
        Blob csvFileBody =cvList[0].VersionData;
        String csvAsString= csvFileBody.toString();
        List<String> csvFileLines= csvAsString.split('\n');
        system.debug(csvFileLines);
        
        Map<string,integer> productCodeWithQty = new Map<string,integer>();
        
        List<string> orderLinesWithQty = new List<string>();
        
        List<String> columnvalue  = new List<string>();
        for(Integer i=0; i<csvFileLines.size(); i++){
            string[] csvRecordData1 = csvFileLines[i].split(',');
            columnvalue.add(csvRecordData1[0]); // here 0 indicates the no. of column from which value you want to store 
            
            productCodeWithQty.put(csvRecordData1[0], Integer.valueOf(csvRecordData1[1].trim()) );
            
            orderLinesWithQty.add(csvRecordData1[0]+'_'+Integer.valueOf(csvRecordData1[1].trim()));
        }
        
        system.debug(columnValue);
        
        system.debug(productCodeWithQty);
        
       	return orderLinesWithQty;
        //return productCodeWithQty;
        //return isFileValid;
        //return [SELECT Id, Title, FileType FROM ContentDocument WHERE Id IN :documentIds AND Title like: fileName]; 
    } 
    
    public static Map<string,boolean>  validateWithExistingProducts(Set<string> productCodes){
        Map<string,boolean> ProductCodeValidation = new Map<string, boolean>(); 
        system.debug('productCodes::'+productCodes);
        /**
        List<Product2> allProducts = [Select Id, Name, StockKeepingUnit, IsActive from Product2 where IsActive=true
                                      and StockKeepingUnit in:productCodes];
		**/
        
        //check in pricebookentry too:
        List<PriceBookEntry> allProductsPBE = [Select Id, Product2Id, IsActive, Product2.IsActive, Product2.StockKeepingUnit from PricebookEntry 
                                               where Product2.IsActive=true and IsActive=true and Product2.StockKeepingUnit in: productCodes
                                               and pricebook2.name='Dealer Price Book' ];
        /**
        if(allProducts.size()>0){
            for(Product2 prod: allProducts )
            {
                ProductCodeValidation.put(prod.stockkeepingunit,true);
            }
        }
        **/
        if(allProductsPBE.size()>0){
            for(PricebookEntry prodPBE: allProductsPBE )
            {
                ProductCodeValidation.put(prodPBE.Product2.stockkeepingunit,true);
                
            }
        }        
        system.debug(ProductCodeValidation);
        return ProductCodeValidation;
    }
    
    public void importCSVFile(){
        try{
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n'); 
            
            for(Integer i=1;i<csvFileLines.size();i++){
                Account accObj = new Account() ;
                string[] csvRecordData = csvFileLines[i].split(',');
                accObj.name = csvRecordData[0] ;             
                accObj.accountnumber = csvRecordData[1];
                accObj.Type = csvRecordData[2];
                accObj.AccountSource = csvRecordData[3];   
                accObj.Industry = csvRecordData[4];                                                                             
                acclist.add(accObj);   
            }
            //insert acclist;
        }
        catch (Exception e)
        {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }  
    }
    
}