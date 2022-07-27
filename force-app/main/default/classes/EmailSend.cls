public class EmailSend {
    @AuraEnabled
    public static String sendingEmail(){
        list<Messaging.SingleEmailMessage> emailObj = new list<Messaging.SingleEmailMessage>();
        String[] address = new String[] { '0056t000000QK7UAAW' };
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSubject('Test Email');
        message.setToAddresses(address);
        message.setPlainTextBody('Please connect with your Buyer');
        
        emailObj.add(message);
        String msg = '';
        if(!emailObj.isEmpty()){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailObj);
            
            
            if (results[0].success) {
                msg = 'Your representative will connect with you soon';
            } else {
                msg = 'Due to some error email was not sent';
            }
        }
            
       return msg; 
        
    }
}