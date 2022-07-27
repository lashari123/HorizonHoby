public with sharing class TemporaryImageController {
    
    @AuraEnabled(cacheable=true)
    public static list<string> getImages(string productID){
        
        attachment[] images = [select id,name from attachment where parentId = :productID];
        list<string> imagesURL = new list<string>();
        for(attachment image : images ){
            string url = '../servlet/servlet.FileDownload?file='+image.id;
            imagesURL.add(image.id);
        }
        system.debug(imagesUrl);
        return imagesURL;
    }
}