public class OrderTriggerHandler {
    
    public void sendDataToMs(list<order> orders){
        //do something
        string ordersToJSON = JSON.serializePretty(orders);
        system.debug(ordersToJSON);
    } 

}