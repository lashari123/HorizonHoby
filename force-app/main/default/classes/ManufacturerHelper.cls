public class ManufacturerHelper {
	
    public static void uploadImageByAnonymous(string RecordId,string Base64String,string stringName) {
        
       /* List<Folder> folderList = [SELECT Id, Name From Folder WHERE Name = 'B2B General Documents'];
        String docFolderId = folderList[0].Id; //Get Folder Id*/
        String fileContent = Base64String;
       // Datetime currentDT = System.now();
        // String fileName = 'Media POC Image'; //Timestamp for unique file name
        
        Attachment newImage = new Attachment();
        
        newImage.Name = stringName;
        newImage.Body = EncodingUtil.base64Decode(fileContent);
        newImage.ContentType = 'image/jpeg';
        newImage.ParentId = RecordId;
        
        //return NewImage;
        
        insert newImage;
        
            Manufacturer__c man = new Manufacturer__c(
                id= recordId,
                Logo_Id__c =newImage.Id
                
            );
            update man;
    }
    
    public static List<Manufacturer__c> getManufacturers(){
        List<Manufacturer__c> manList = new List<Manufacturer__c>();
        manList = [select id, Name from Manufacturer__c];
        return manList;
    }
    
}