public class mulesoftHandler {
    
    public static string m_Username;
    public static string m_password;
    public static string m_baseUrl;
    public static tokenWrapper token;
    // get credential from custom setting "Epcred".
    Public static void getCredential(){
        
        Epcred__c cred =  Epcred__c.getOrgDefaults();
        m_Username = cred.Username__c;
        m_Password = cred.Password__c; 
        m_baseUrl = cred.BaseUrl__c;
    }
    
    
    // APIs for getting
    public static tokenWrapper getToken(){
        
        getCredential();
        
        Http protocol = new Http();
        
        HttpRequest request = new HttpRequest();
        string param = '?username='+m_Username+'&password='+m_password;
        system.debug('https://anypoint.mulesoft.com/accounts/login?username=ibad_mohiuddin&password=Ibadmo111');
        system.debug(m_baseUrl + '/accounts/login'+param);
        request.setEndpoint(m_baseUrl + '/accounts/login'+param);
        request.setMethod('POST');
        request.setHeader('Accept', '*/*'); 
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept-Encoding', 'gzip, deflate, br');
        request.setHeader('Connection', 'keep-alive');
        
        
        
        //  Blob headerValue = Blob.valueOf(m_username + ':' + m_password);
        
        //   String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        //request.setHeader('Authorization', authorizationHeader);
        request.setTimeout(120000);
        
        HttpResponse response = protocol.send(request );
        
        /*
[
{
"firstName": "test1",
"lastName": "AN",
"mobilePhone": "0345124244"

},
{
"firstName": "test2",
"lastName": "AN2",
"mobilePhone": "03451242442"
}
]

*/
        System.debug('body22222===='+response.getBody());
        
        string dummyResponse= '[ { "firstName": "test1", "lastName": "AN", "mobilePhone": "0345124244" }, { "firstName": "test2", "lastName": "AN2", "mobilePhone": "03451242442" } ]';
        
        tokenWrapper resBody = (  tokenWrapper ) JSON.deserialize(response.getBody(), tokenWrapper.class);
        
        //system.debug(' body length: '+ resBody.size());
        system.debug(' body : '+ resBody);
        
        //   insert resbody;
        return resBody;
        
        
    }
    
    public  class tokenWrapper{
        
        public string access_token='';
        public string token_type= '';
        public string redirectUrl= '';
    }
}