@isTest
public class ProductHelper_Test {

    static testMethod void PricebookEntry(){
        
        
         PricebookEntry pbe = new  PricebookEntry();
         pbe.UnitPrice = 232;
      	 pbe.IsActive = true;
         Product2 pro = new Product2();
     	 pbe.Product2Id = '01s6t0000008f74AAA';
         pro.Name = 'Dealer Price Book';
         pro.Description = 'tester';
         pro.PrimaryImageID__c = 'image';  
         Attachment newImage = new Attachment();
         newImage.Name = 'Media POC Image';
         newImage.Body = blob.valueOf('Base64String');
         newImage.ContentType = 'image/jpeg';
         newImage.ParentId = '00l6t000000HrODAA0';
         Folder fol = new  Folder();
         fol.Id = '00l6t000000HrODAA0';
         fol.Name = 'B2B General Documents';
    //    fol.CreatedDate = 'gmt';
         fol.IsReadonly = true;
        
       insert pro;
       
        ProductHelper.getTopSellingProducts();
 	 }     
  }