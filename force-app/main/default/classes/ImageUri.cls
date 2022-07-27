public class ImageUri {
    public static String getDataUriFromUri(String url) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        Http binding = new Http();
        HttpResponse res = binding.send(req);
        Blob image = res.getBodyAsBlob();
        return 'data:'+res.getHeader('Content-Type')+';base64,'+EncodingUtil.base64Encode(image);
    }
}