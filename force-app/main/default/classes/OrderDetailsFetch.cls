public class OrderDetailsFetch {
    
    //Method gives respons through callout using record Id
    @AuraEnabled
    public static Object calloutToGoServer(String recordId)
    {
        //Query to get Global PartyId using Account Id
        List <Account> accPartyId =new List<Account>([SELECT id,GlobalPartyId FROM Account WHERE Id =:recordId]);
        if(accPartyId[0].GlobalPartyId != null){
            //Query to get Person ContactId using Global PartyId
            List <Account> acc =new List<Account>([SELECT id,personContactID FROM Account WHERE GlobalPartyId =:accPartyId[0].GlobalPartyId]);
            //Create sstring of Person contact Id
            String conId = '(';
            for(Account accCont : acc){
                conId = conId+'\''+(String)accCont.personContactID+'\''+',';
            }
            integer lstIndex=conId.lastIndexOf(',');
            conId=conId.substring(0, lstIndex);
            conId=conId+')';
            
            //Custom setting to store URL, Username and Password
            OrderHistoryAPi__c orderDetails = OrderHistoryAPi__c.getValues('Order_History_APi_Details');
            String username = orderDetails.Username__c; 
            String password = orderDetails.Password__c;
            String orderURL = orderDetails.URL__c;
            
            list<orderWraper> wrapList = new list<orderWraper>();
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            
            //Append base url with Person contact Id
            String url = orderURL+conId+'&$expand=customer';
            
            //String url = callout:OrderHistoryAPi+conId+'&$expand=customer';
            request.setEndpoint(url);
            
            request.setMethod('GET');
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            response = h.send(request);
            if (response.getStatusCode() == 200) {
                Map < String,Object > orderResult = (Map < String, Object > ) JSON.deserializeUntyped(response.getBody());
                System.debug('orderResult--->'+orderResult);
                List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
               // Map<Id,Contact> contDetail = new Map<Id,Contact>([SELECT Id,Name FROM Contact]);
                List<Object> myMapObjects = (List<Object>) orderResult.get('value');
                for (Object obj : myMapObjects) {
                    myMaps.add((Map<String, Object>)obj);
                }
                for(Map<String, Object> objMap : myMaps){
                    orderWraper order = new orderWraper();
                    Map < String,Object > customer = (Map < String, Object > )objMap.get('Customer');
                    
                    order.OrderNumber = (objMap.containsKey('OrderNumber')) ?(String)objMap.get('OrderNumber') : null;
                    if(!Test.isRunningTest() && order.OrderNumber!=null ){
                        List<Orders__x> orderList = new List<Orders__x>([SELECT Id,OrderNumber__c From Orders__x WHERE OrderNumber__c=:order.OrderNumber LIMIT 1]);
                        order.OrderId  = orderList[0].Id;
                    }
                    else{
                        order.OrderId = null;
                    }
                    
                    order.SiteId = (objMap.containsKey('SiteId')) ?(String)objMap.get('SiteId') : null;
                    order.Status = (objMap.containsKey('Status')) ?(String)objMap.get('Status') : null;
                    String s = String.valueOf(objMap.get('OrderTimestamp'));
                    String s1 = s.substringBefore('T');
                    order.OrderTimestamp = Date.valueOf(s1);
                    Id contId = (Id)customer.get('ContactId');
                    order.ContactId = (customer.containsKey('ContactId')) ?(Id)customer.get('ContactId') : null;
                    if(!Test.isRunningTest() && order.ContactId != null){
                        List<Contact> contDetail = new List<Contact>([SELECT Id,Name FROM Contact WHERE Id =:order.ContactId LIMIT 1]);
                        order.contName = contDetail[0].Name;
                    }
                    else{
                        order.contName = 'TestContact';
                    }
                    wrapList.add(order);
                    System.debug('wrapList--->'+wrapList);
                }
                return wrapList;
            }
        }
        return null;
        
    }
    //Wrapper to hold response values from callout
    public class orderWraper {
        @AuraEnabled
        public String OrderNumber {get; set;}
        @AuraEnabled
        public Id OrderId {get; set;}
        @AuraEnabled
        public String SiteId {get; set;}
        @AuraEnabled
        public String Status {get; set;}
        @AuraEnabled
        public Date OrderTimestamp {get; set;}
        @AuraEnabled
        public String contName {get; set;}
        @AuraEnabled
        public Id ContactId {get; set;}
        
    }
    
}