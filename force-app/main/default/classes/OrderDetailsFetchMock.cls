@isTest
global class OrderDetailsFetchMock implements HTTPCalloutMock {
    
    // Creating a fake response
    global HTTPResponse respond(HTTPRequest request) {
        HTTPResponse response = new HTTPResponse();
        // Setting the response body
        response.setBody('{"value":[{"Id":268,"OrderNumber":"HHUS000005516","SiteId":"horizon-us","CreatedBy":"storefront","IsGuestOrder":false,"OrderTimestamp":"2020-06-09T20:11:54.707Z","Status":"Shipped","Currency":"USD","ShippingMethod":"022","ShippingAddressName":"CALLUM MCFARLAND","ShippingAddressLine1":"70 OLD STREET","ShippingAddressLine2":"","ShippingAddressCity":"OPTIO QUIA LABORE ATQ","ShippingAddressStateCode":"","ShippingAddressPostalCode":"16537","ShippingAddressCountryCode":"RU","ShippingAddressPhoneNumber":"2222222222","BillingAddressName":"JUSTINE SPEARS","BillingAddressLine1":"70 OLD STREET","BillingAddressLine2":"","BillingAddressCity":"OPTIO QUIA LABORE ATQ","BillingAddressStateCode":"","BillingAddressPostalCode":"16537","BillingAddressCountryCode":"RU","BillingAddressPhoneNumber":"2222222222","CustomerId":159058,"OrderValueId":null,"Customer":{"Id":159058,"CustomerName":null,"Email":null,"OrdersAllowed":false,"EasyPayAllowed":false,"ContactId":"0033B00000WWLIUQA5"}}]}');
        // Setting the response header
        response.setHeader('Content-Type', 'application/json');
        // Setting the response code
        response.setStatusCode(200);
        // Returning the response
        return response;
    }
}