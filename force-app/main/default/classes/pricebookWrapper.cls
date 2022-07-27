public class pricebookWrapper{
    public cls_attributes attributes;
    public String Name;	//HEU - Tier A
    public boolean IsActive;
    public String ExternalId;	//HEU-21
    public String Currency1;	//EUR
    
    class cls_attributes {
        public String type;	//Pricebook
    }
    
    public static pricebookWrapper parse(String json){
        return (pricebookWrapper) System.JSON.deserialize(json, pricebookWrapper.class);
    }
    
    
}