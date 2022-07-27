public class RMARequestController {
	@AuraEnabled
    public static RMARequestWrapper getAccountData(){
        List<Account> acc = new List<Account>();
        List<Contact> con = new List<Contact>();
        String contactId = [Select Id, contactid from User where Id =: Userinfo.getUserid()].contactid;
        con  = [Select Id, AccountID, Name, Phone from Contact where Id =: contactid];
        acc = [SELECT Id, AccountNumber,Name FROM Account WHERE Id =: con[0].AccountId];
        RMARequestWrapper rmawrapper = new RMARequestWrapper();
        rmawrapper.accountNumber = acc[0].AccountNumber;
        rmawrapper.accountName = acc[0].Name;
        rmawrapper.contactPhone = con[0].Phone;
        rmawrapper.contactName = con[0].Name;

        return rmawrapper;
    }
    
    public Class RMARequestWrapper{
        @AuraEnabled
        public string accountNumber {get;set;}
        @AuraEnabled
        public string accountName {get;set;}
        @AuraEnabled
        public string contactPhone {get;set;}
        @AuraEnabled
        public string contactName {get;set;}
    }
    
     @AuraEnabled
    public static id uploadFile(Id parentId, String fileName, String base64Data, String contentType)
    {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        
        insert oAttachment;        
        return oAttachment.Id;
        
    }
    
    @AuraEnabled 
    public static case submitCases(string Subject)
    {
        user user1 = [Select contactId from user where id = :UserInfo.getUserId() limit 1 ];
        Contact conId = [SELECT id from Contact where id = : user1.contactId limit 1] ;
        case c = new case(subject = Subject,contact = conId);
        insert c;
        
        return [SELECT Id, CaseNumber FROM Case where id = :c.Id];
    } 
    
      @AuraEnabled
    public static void deleteDocument(string DocId){
        delete [SELECT Id, ParentId, ContentAssetId FROM ContentDocument where id = :DocId];
    }

}