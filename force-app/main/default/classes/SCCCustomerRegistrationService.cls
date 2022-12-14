/**
* Rest Service class for post contact informations' details => Customer Registration
*
*
* @author  Neeraj Yadav
* @version 1.0
* @since   2017-11-02
*/
@RestResource(urlMapping='/Contact/Registration/*')
global with sharing class SCCCustomerRegistrationService {

    /**
    * This is the method using on "GET" requests.
    * @return List<Account>.
    */
    @HttpGet
    global static List<Account> show() {
        Id recordId = RestContext.request.requestURI.replace('/Contact/Registration/', '');
        List<Account> returnList = new List<Account>();
        String query = SCCQueryUtilClass.getInstance()
                .getQueryInstance()
                .setObjectName('Account')
                .setAllFields()
                .setClause('Id = \'' + recordId + '\' OR PersonContactId = \'' + recordId + '\'')
                .getQuery();
        returnList = (List<Account>)SCCQueryUtilClass.getRecords(query);
        return returnList;
    }

    /**
    * This is the method using on "POST" requests
    * @return SCCCustomerRegResponse.
    */
    @HttpPatch
    global static SCCCustomerRegResponse updateModify() {
        SCCFileLogger logger = SCCFileLogger.getInstance();
        SCCCustomerRegResponse response;
        try{
            if(SCCUtilityClass.isPersonAccountEnabled()){
                response = createAccountRecord(RestContext.request, logger);
            }else{
                response = createContactRecord(RestContext.request, logger);
            }
        }catch(Exception e){
            logger.error('SCCCustomerRegistrationService.create', 'Exception message : '
                         + e.getMessage() + ' StackTrack '+ e.getStackTraceString());
        }finally{
            logger.flush();
        }
        return response;
    }

    /**
    * This is the method using on "POST" requests
    * @return SCCCustomerRegResponse.
    */
    @HttpPost
    global static SCCCustomerRegResponse create() {
        SCCFileLogger logger = SCCFileLogger.getInstance();
        SCCCustomerRegResponse response;
        try{
            if(SCCUtilityClass.isPersonAccountEnabled()){
                response = createAccountRecord(RestContext.request, logger);
            }else{
                response = createContactRecord(RestContext.request, logger);
            }
        }catch(Exception e){
            logger.error('SCCCustomerRegistrationService.create', 'Exception message : '
                         + e.getMessage() + ' StackTrack '+ e.getStackTraceString());
        }finally{
            logger.flush();
        }
        return response;
    }

    /**
    * This is the method using on "POST" requests
    * @return SCCCustomerRegResponse.
    */
    static SCCCustomerRegResponse createAccountRecord(RestRequest request, SCCFileLogger logger){
        try 
        {
            SCCCommerceCloudConnect.logger = logger;
            logger.debug('SCCCustomerRegistrationService.createAccountRecord', 'request: ' + request);
            Map<String, SObject> fieldMappings = SCCUtilityClass.getAllCustomSettingValues('Account', logger);
            Map<String, Object> jsonMap = (Map<String, Object>)System.JSON.deserializeUntyped(request.requestBody.toString());
            Set<String> relatedFields;
            String clause;

            // First, evaluate if a customer-number was included in the registration details
            // if (jsonMap.get('customer_no') != null && jsonMap.get('customer_no') != ''){
            //     // Resolution criterion 1: search via customer_no
            //     relatedFields = new Set<String>{'Id', 'PersonEmail','SFCC_Customer_Number__pc','SFCC_Customer_Id__pc'};
            //     // Either match specifically on the customer number
            //     clause = 'SFCC_Customer_Number__pc = \'' + (String)jsonMap.get('customer_no') + '\' ';
            //     // Or, match where the customer numbers are not the same -- but we have matching email addresses and no login exists
            //     clause += 'or ( SFCC_Customer_Number__pc != \'' + (String)jsonMap.get('customer_no') + '\' and PersonEmail = \'' + (String)jsonMap.get('email') + '\'  and SFCC_Customer_Id__pc = NULL)';
            // } else if (jsonMap.get('customer_id') != null && jsonMap.get('customer_id') != ''){
            //     // Resolution criterion 2: search via customer_id
            //     relatedFields = new Set<String>{'Id', 'PersonEmail','SFCC_Customer_Number__pc','SFCC_Customer_Id__pc'};
            //     clause = 'SFCC_Customer_Id__pc = \'' + (String)jsonMap.get('customer_id') + '\'';
            // } else {
                // Resolution criterion 3: if neither of customer_no or customer_id present in request, resolve via email
                // relatedFields = new Set<String>{'Id', 'PersonEmail','SFCC_Customer_Number__pc','SFCC_Customer_Id__pc'};
                // clause = 'PersonEmail = \'' + (String)jsonMap.get('email') + '\'';
                // Resolution criterion 3: if neither of customer_no or customer_id present in request, resolve via email and Channel/Site
                
            if (jsonMap.get('contact_id') != null && jsonMap.get('contact_id') != ''){
                relatedFields = new Set<String>{'Id','PersonContactId','SFCC_Customer_Number__pc','SFCC_Customer_Id__pc'};
                    clause = 'PersonContactId = \'' + (String)jsonMap.get('contact_id') + '\'';   
            }
            else if (jsonMap.get('account_id') != null && jsonMap.get('account_id') != ''){
                relatedFields = new Set<String>{'Id','SFCC_Customer_Number__pc','SFCC_Customer_Id__pc'};
                    clause = 'Id = \'' + (String)jsonMap.get('account_id') + '\'';   
            }
            else if (jsonMap.get('email') != null && jsonMap.get('email') != '') {
                relatedFields = new Set<String>{'Id', 'PersonEmail','SFCC_Customer_Number__pc','SFCC_Customer_Id__pc', 'Channel__pc'};
                    clause = 'PersonEmail = \'' + (String)jsonMap.get('email') + '\' and Channel__pc = \'' + (String)jsonMap.get('site_name') + '\''; 
            }
            else if (jsonMap.get('customer_no') != null && jsonMap.get('customer_no') != '') {
                relatedFields = new Set<String>{'Id', 'PersonEmail','SFCC_Customer_Number__pc','SFCC_Customer_Id__pc', 'Channel__pc'};
                    clause = 'SFCC_Customer_Number__pc = \'' + (String)jsonMap.get('customer_no') + '\''; 
            }
            else if (jsonMap.get('customer_id') != null && jsonMap.get('customer_id') != '') {
                relatedFields = new Set<String>{'Id', 'PersonEmail','SFCC_Customer_Number__pc','SFCC_Customer_Id__pc', 'Channel__pc'};
                    clause = 'SFCC_Customer_Id__pc = \'' + (String)jsonMap.get('customer_id')  + '\''; 
            } 
            

                System.debug(LoggingLevel.INFO, 'clause ' + clause);
          

            String query = SCCQueryUtilClass.getInstance()
                                            .getQueryInstance()
                                            .setObjectName('Account')
                                            .setRelatedFields(relatedFields)
                                            .setClause(clause)
                                            .getQuery();
            system.debug('Query------------------------>'+query);
            List<Account> accountList = (List<Account>)SCCQueryUtilClass.getRecords(query);
            Account record = (Account)SCCUtilityClass.initializeObject(jsonMap, 'Account', fieldMappings, logger);
            record.From_SFCC__pc = true;
            record = SCCUtilityClass.additionalFieldsforAccount(record, jsonMap);
            if(!accountList.isEmpty()) 
            {
                logger.debug('SCCCustomerRegistrationService.createAccountRecord', 'Updating existing account: '+accountList);
                record.Id = accountList[0].Id;
                record.Contact_Status__pc  = 'Updated';
                record.SFCC_update__c = true;
            }
            else
            {
                logger.debug('SCCCustomerRegistrationService.createAccountRecord', 'Creating new account');
                RecordType recordType = SCCUtilityClass.getPersonAccountRecordType('Person Account');
                if (String.isBlank(record.LastName) && String.isNotBlank(record.PersonEmail)) 
                {
                    List<String> emailParts = record.PersonEmail.split('@');
                    record.LastName = emailParts.get(0);
                }
                record.RecordTypeId = recordType.Id;
                record.Contact_Status__pc  = 'Created';
            }
            Database.upsert(record, true);
            //SCCCommerceCloudConnect.scheduleIt(record.Id);
            SCCCommerceCloudConnect.synchroniseObjectFuture(record.Id);
            return SCCCustomerRegResponse.createResponse(record);
        } 
        catch(Exception e) 
        {
            RestContext.response.statusCode = 500;
            logger.error('SCCCustomerRegistrationService.createAccountRecord', 'Exception message : '
                         + e.getMessage() + ' StackTrack '+ e.getStackTraceString());
            return SCCCustomerRegResponse.createError(e);
        }
    }

    public static SCCCustomerRegResponse createContactRecord(RestRequest request, SCCFileLogger logger)
    {
        try 
        {
            SCCCommerceCloudConnect.logger = logger;
            Map<String, SObject> fieldMappings = SCCUtilityClass.getAllCustomSettingValues('Contact', logger);
            Map<String, Object> jsonMap = (Map<String, Object>)System.JSON.deserializeUntyped(request.requestBody.toString());
            String query = SCCQueryUtilClass.getInstance()
                                          .getQueryInstance()
                                          .setObjectName('Contact')
                                          .setRelatedFields(new Set<String>{'Id', 'Email'})
                                          .setClause('Email = \'' + (String)jsonMap.get('email') + '\'')
                                          .getQuery();
            system.debug('Query------------------------>'+query);
            List<Contact> contactList = (List<Contact>)SCCQueryUtilClass.getRecords(query);
            Contact record = (Contact)SCCUtilityClass.initializeObject(jsonMap, 'Contact', fieldMappings, logger);
            record.From_SFCC__c = true;
            record = SCCUtilityClass.additionalFieldsforContact(record, jsonMap);
            if(!contactList.isEmpty()) 
            {
                logger.debug('SCCCustomerRegistrationService.createContactRecord', 'Updating existing contact: '+contactList);
                record.Id = contactList[0].Id;
                record.Contact_Status__c  = 'Updated';
            }
            else
            {
                logger.debug('SCCCustomerRegistrationService.createContactRecord', 'Creating new contact');
                record.Contact_Status__c  = 'Created';
            }
            Database.upsert(record, true);
            SCCCommerceCloudConnect.scheduleIt(record.Id);
            return SCCCustomerRegResponse.createResponse(record);
        } catch(Exception e) {
            RestContext.response.statusCode = 500;
            logger.error('SCCCustomerRegistrationService.createContactRecord', 'Exception message : '
                         + e.getMessage() + ' StackTrack '+ e.getStackTraceString());
            return SCCCustomerRegResponse.createError(e);
        }
    }
}