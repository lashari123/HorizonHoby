public class pricebookentryHelper {
    
    public static void getPricebookentries(){
        
        // commenting because TOKEN is no longer necessary
        //For Getting token for accessing API
        
        //mulesoftHandler.tokenWrapper token =  mulesoftHandler.getToken();
        
        mulesoftHandler.getCredential();
        
        // Hitting API For fetching Product
        Http protocol = new Http();
        HttpRequest request = new HttpRequest();
        
        system.debug(mulesoftHandler.m_baseUrl + '/accounts/login'	);
        
        //old Endpoint not in use
        // request.setEndpoint(mulesoftHandler.m_baseUrl + '/mocking/api/v1/links/f9558e2a-0c79-432d-b544-0a67c4fa66f4/products');
        
        request.setEndpoint(mulesoftHandler.m_baseUrl + '/mocking/api/v1/sources/exchange/assets/41a75cd2-c0e2-4e87-ace1-108af8abd73f/exp-b2bCommerce-web-api/0.2.0/m/pricebook-entries?siteId=fastserver-eu');
        request.setMethod('GET');
        request.setHeader('Accept', '*/*'); 
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept-Encoding', 'gzip, deflate, br');
        request.setHeader('Connection', 'keep-alive');
        request.setHeader('client_id' ,'abc');
        request.setHeader('client_secret' ,'abc');    
        request.setTimeout(120000);
        
        //commenting because token is not in use       
        // string auth = 'Bearer ' +token.access_token;
        //request.setHeader('ms2-authorization' ,auth); 
        
        // Response from API
        HttpResponse response = protocol.send(request );
        System.debug('body22222===='+response.getBody());
        
        
        // if Error occur save in error message and then create integration_log__c
        string errorMessage = '';
        integer errorCount = 0;
        
        if(response.getStatusCode() != 200 ){
            errorCount ++;
            errorMessage = 'API Failed with Status Code: <b>' + response.getStatusCode() + '</b><br/> <b>Error Body:</b> ' + response.getBody();
        }
        
        if(response.getStatusCode() == 200){
            
            //desirializing response to object 
            //Object productData = JSON.deserializeUntyped(response.getBody());
            
            //Replacing __c by null because it will raising an error and currency by currency1 because currency is system reserved
            string responseStr = response.getBody().replaceAll('__c',  '');
            
            system.debug(responseStr);
            
            //Deserializing response to our wrapper class  
            list<pricebookentryWrapper> pws  = (list<pricebookentryWrapper>)JSON.deserialize(responseStr, list<pricebookentryWrapper>.class);
            
            //list of product to insert 
            List<pricebookentry> pricebookentries = new list<pricebookentry>();
            
            for(pricebookentryWrapper pw: pws){
                
                PricebookEntry pbe = new PricebookEntry();
                //pbe.ActivePriceAdjustmentQuantity = pw.ActivePriceAdjustmentQuantity;
                pbe.IsActive = pw.IsActive;
                pbe.UnitPrice = pw.UnitPrice;
                pbe.MixAndMatchCode__c = pw.mmCode;
                
                //getting product
                product2 prd = new product2(externalId__c = pw.ProductId );
                pbe.Product2 = prd;
                
                //getting pricebook
                Pricebook2 pb = new Pricebook2(externalId__c = pw.PricebookId);
                pbe.Pricebook2 = pb;
                
                pricebookentries.add(pbe);
            }
            
            // return save results 
            list<Database.SaveResult> srList = database.insert( pricebookentries,false);
            
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else {
                    errorCount ++;
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        ErrorMessage += '\n'+ err.getStatusCode() + ': ' + err.getMessage() ;
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        
        
        //if ErrorMessage has value create a integration log
        if(string.isNotBlank(errorMessage)){
            
            Integration_Log__c il = new Integration_Log__c();
            
            il.API_Name__c = 'PricebookEntry';
            il.errorMessage__c = 'Total Number of failed record: '+errorCount +' ' +errorMessage;
            
            insert il;
        }
        
    }  
}