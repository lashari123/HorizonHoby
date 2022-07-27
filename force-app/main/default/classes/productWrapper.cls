public class productWrapper{
    public cls_attributes attributes;
    public cls_Name[] Name;
    public String ProductCode;	//ARA4303V3T1
    public cls_Description[] Description;
    public boolean IsActive;
    public String ProductClass;	//Proprietary
    public String ExternalId;	//ARA4303V3T1
    public String Manufacturer;	//ARA
    public String QuantityUnitOfMeasure;	//Each
    public String FirstAppearance;	//2020-04-13
    public String ETA;	//2021-10-11
    public String LastInStock;	//2021-06-13
    public String InventoryStatus;	//
    public String ShippingClass;	//NONE
    public String ManufacturerName;	//ARRMA
    public String UPC;	//5052127038294 
    public Integer Rank;	//254
    public double SalesMultiple;	//1
    public string Availability;
    public string LastUpdated;
    
   // public product2 product;
 
    public cls_images[] images;
    class cls_attributes {
        public String type;	//Product2
    }
    public class cls_Name {
        public String localeId;	//en
        public String value;	//1/10 SENTON 4X4 V3 3S BLX Brushless Short Course Truck RTR, Blue
    }
    public class cls_Description {
        public String localeId;	//en
        public String value;	//.safeTech h4 {color:#fff;} 	</style> 	<style> 	.aligncenter { 		text-align: center; 	} 	</style> 	    <!-- Start Features --> <div id=""featureListDiv"" class=""wrapDiv""> 	<h3 id=""featureList"">Features</h3> </div> <div id=""featureListDiv"" class=""row""> 	<div class=""columns col-lg-6 col-sm-12""> 		<ul>  					   <li> Stronger chassis and retained hinge pin plates</li> <li> Steering with more clearance for stones</li> <li> Castellated slipper pad and sliding gear mesh</li> <li> Plastic locknut for slipper</li> <li> 23T Spline servo saver </li> <li> 37T 1.35Mod diffs with silicone O-rings</li>  <li> Power Module with sliding gear mesh and improved dirt management</li> <li> Rubber shielded bearings throughout <li> Oil-filled shocks with silicone O-rings</li> <li> Front and rear bumpers</li> <li> Tough gunmetal colored multi-spoke wheels</li> <li> Vented multi-terrain dBoots&#174; Fortress&#8482; SC tires</li>  <li> BLX100 2S/3S waterproof* ESC<br> <div class=""small"">*For details on waterproof standards
        
    }
    public class cls_images {
        public string base64;
        public boolean isPrimary;
        public String url;	//https://www.horizonhobby.com/dw/image/v2/BFBR_PRD/on/demandware.static/-/Sites-horizon-master/default/Images/ARA/ARA4303V3T1_A0_8PVTS0PI.jpg
    }
    
    
    
    public static productWrapper parse(String json){
        return (productWrapper) System.JSON.deserialize(json, productWrapper.class);
    }
    
    
    
    
}