public class pricebookHelper {
    
    public static void getPricebooks(){
        
        // commenting because TOKEN is no longer necessary
        //For Getting token for accessing API
        
        //mulesoftHandler.tokenWrapper token =  mulesoftHandler.getToken();
        
        mulesoftHandler.getCredential();
        
        // Hitting API For fetching Product
        Http protocol = new Http();
        HttpRequest request = new HttpRequest();
        
        system.debug(mulesoftHandler.m_baseUrl + '/accounts/login'	);
        
        request.setEndpoint(mulesoftHandler.m_baseUrl + '/mocking/api/v1/sources/exchange/assets/41a75cd2-c0e2-4e87-ace1-108af8abd73f/exp-b2bCommerce-web-api/0.2.0/m/pricebooks?siteId=fastserver-eu');
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
        System.debug('body===='+response.getBody());
        
        // if Error occur save in error message and then create integration_log__c
        string errorMessage = '';
        integer errorCount = 0;
        
        if(response.getStatusCode() != 200 ){
            
            errorCount ++;
            errorMessage = 'API Failed with Status Code: <b>' + response.getStatusCode() + '</b><br/> <b>Error Body:</b> ' + response.getBody();
        }
        
        if(response.getStatusCode() == 200){
           
            //Replacing __c by null because it will raising an error and currency by currency1 because currency is system reserved
            string responseStr = response.getBody().replaceAll('Currency',  'Currency1'); 
            responseStr = responseStr.replaceAll('__c',  '');
            
            system.debug(responseStr);
            
            //Deserializing response to our wrapper class  
            list<pricebookWrapper> pws  = (list<pricebookWrapper>)JSON.deserialize(responseStr, list<pricebookWrapper>.class);
            
            //list of pricebooks to insert 
            List<pricebook2> pricebooks = new list<pricebook2>();
            
            for(pricebookWrapper pw: pws){
                Pricebook2 pb = new priceBook2();
                pb.Currency__c  = pw.currency1;
                pb.ExternalId__c = pw.ExternalId;
                pb.IsActive = pw.IsActive;
                pb.Name = pw.name;
                pricebooks.add(pb);
            }
            
            // return save results 
            list<Database.SaveResult> srList = database.insert( pricebooks,false);
            
            
            
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
                        ErrorMessage += '<br/>'+ err.getStatusCode() + ': ' + err.getMessage() ;
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        
        
        //if ErrorMessage has value create a integration log
        if(string.isNotBlank(errorMessage)){
            
            Integration_Log__c il = new Integration_Log__c();
            
            il.API_Name__c = 'pricebook';
            il.errorMessage__c = 'Total Number of failed record: '+errorCount +' ' +errorMessage;
            
            insert il;
        }
        // map of wrapperclass by product external id use for inserting images and translation
        //  map<string,pricebookWrapper> wrapperByProduct = new map<string,pricebookWrapper>();
        
        
        
    }
    
}