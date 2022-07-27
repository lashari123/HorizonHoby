public class pricebookentryWrapper {
	public cls_attributes attributes;
	public String PricebookId;	//HEU-21
	public String ProductId;	//LOS05014V2T1
	public Double UnitPrice;	//1008.82
	public boolean IsActive;
	public Integer ActivePriceAdjustmentQuantity;	//6
	public String mmCode;	//asdf1234
	class cls_attributes {
		public String type;	//PricebookEntry
	}
	public static pricebookWrapper parse(String json){
		return (pricebookWrapper) System.JSON.deserialize(json, pricebookWrapper.class);
	}

}