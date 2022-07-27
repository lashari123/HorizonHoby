@isTest (seeAllData=true)
public class TestFactory 
{
    public static List<Account> createPersonAccount(Integer num)
    {
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount'];
        List<Account> testPersonAccountList = new List<Account>();
        
        for(Integer i=0; i<num; i++)
        {
            Account persAcct = new Account();
            persAcct.FirstName = 'TestFirst' + String.valueOf(i);
            persAcct.LastName = 'TestLast' + String.valueOf(i);
            
            persAcct.PersonEmail = 'testfirst' + String.valueOf(i) + '.' + 'testlast' + String.valueOf(i) + '@horizonhobby.com';
            persAcct.Email2__pc = 'testfirst' + String.valueOf(i) + '.' + 'testlast' + String.valueOf(i) + '@horizonhobby2.com';
            persAcct.Email3__pc = 'testfirst' + String.valueOf(i) + '.' + 'testlast' + String.valueOf(i) + '@horizonhobby3.com';
           // persAcct.Email4__pc = 'testfirst' + String.valueOf(i) + '.' + 'testlast' + String.valueOf(i) + '@horizonhobby4.com';
          //  persAcct.Email5__pc = 'testfirst' + String.valueOf(i) + '.' + 'testlast' + String.valueOf(i) + '@horizonhobby5.com';
            persAcct.RecordTypeId = rt.Id;
            
            persAcct.Channel__pc = 'horizon-us';
            
            testPersonAccountList.add(persAcct);
        }
        
        return testPersonAccountList;
    }
    
    public static List<Account> createBusinessAccount(Integer num)
    {
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName = 'Business_Account'];
        List<Account> testBusinessAccountList = new List<Account>();
        
        for(Integer i=0; i<num; i++)
        {
            Account acct = new Account();
            acct.Name = 'Test Account Name ' + String.valueOf(i);
            acct.BillingStreet = String.valueOf(i) + '2345 Test Street';
            acct.BillingCity = 'Portland';
            acct.BillingState = 'Oregon';
            acct.BillingPostalCode = '9711' + String.valueOf(i);
            acct.BillingCountry = 'USA';
            
            acct.Phone = '503-555-1234';
            acct.Type = 'Customer';

            acct.RecordTypeId = rt.Id;
            
            testBusinessAccountList.add(acct);
        }
        
        return testBusinessAccountList;
    }
    
    public static List<Contact> createContacts(Id acctId, Integer num, String emailDomain)
    {
		List<Contact> contactList = new List<Contact>();
        
        for(Integer i=0; i<num; i++)
        {
            Contact c = new Contact();
            c.AccountId = acctId;
            c.FirstName = 'TestFirst ' + String.valueOf(i);
            c.LastName = 'TestLast ' + String.valueOf(i);
            c.MailingStreet = String.valueOf(i) + '2345 Test Street';
            c.MailingCity = 'Portland';
            c.MailingState = 'Oregon';
            c.MailingPostalCode = '9711' + String.valueOf(i);
            c.MailingCountry = 'USA';
            
            c.Channel__c = 'horizon-us';
            c.Email = 'testfirst' + String.valueOf(i) + '.testlast' + String.valueOf(i) + emailDomain;
            
            contactList.add(c);
        }
        
        return contactList;
    }
    
    
    public static List<Case> createCaseFromContact(List<Account> persAcctList, Id ownerId, String suppliedEmail, Boolean useSuppliedEmail)
    {
        List<Case> testCaseList = new List<Case>();
        
        for(Account a : persAcctList)
        {
            Case cs = new Case();
            cs.AccountId = a.Id;

            cs.Subject = 'Test Case Subject';
            cs.Description = 'Test Case Description';
            cs.Status = 'New';
            cs.Sub_Status__c = '';
            cs.Site_Name__c = 'horizon-us';
            
            cs.OwnerId = ownerId;
            if(useSuppliedEmail)
            {
                cs.SuppliedEmail = suppliedEmail;
            }
            else
            {
            	cs.SuppliedEmail = a.PersonEmail;                
            }
            
            testCaseList.add(cs);
        }
        
        return testCaseList;
    }
    
    
    public static List<Case> createTestEmailToCase(Integer num, String emailDomain)
    {
        List<Case> testCaseList = new List<Case>();
        
        for(Integer i=0; i<num; i++)
        {
            Case cs = new Case();
            cs.SuppliedPhone = '555-123-4567';
            cs.Order_Number__c = '';
            cs.Subject = 'Test Case Subject';
            cs.Description = 'Test Case Description';
            cs.Status = 'New';
            
            if(i == 0)
            {
                cs.SuppliedName = 'TestFirst' + String.valueOf(i) + ' TestLast' + String.valueOf(i);
                cs.SuppliedEmail = 'testfirst' + String.valueOf(i) + '.' + 'testlast' + String.valueOf(i) + emailDomain;
            }
            else if(i == 1)
            {
                cs.SuppliedName = 'TestLast' + String.valueOf(i) + ', TestFirst' + String.valueOf(i);
                cs.SuppliedEmail = 'testfirst' + String.valueOf(i) + '.' + 'testlast' + String.valueOf(i) + emailDomain;
            }
            else if(i == 2)
            {
                cs.SuppliedName = 'TestLast' + String.valueOf(i);
                cs.SuppliedEmail = 'testfirst' + String.valueOf(i) + '.' + 'testlast' + String.valueOf(i) + emailDomain;
            }
            else if(i == 3)
            {
                cs.SuppliedName = 'Mr. TestFirst' + String.valueOf(i) + ' TestLast' + String.valueOf(i);
                cs.SuppliedEmail = 'testfirst' + String.valueOf(i) + '.' + 'testlast' + String.valueOf(i) + emailDomain;
            }
            else if(i == 4)
            {
                cs.SuppliedName = 'TestFirst' + String.valueOf(i) + ' TestLast' + String.valueOf(i);
                cs.SuppliedEmail = 'testfirst' + String.valueOf(i) + '.' + 'testlast' + String.valueOf(i) + emailDomain;
            }
            else
            {
                cs.SuppliedName = 'TestFirst' + String.valueOf(i) + ' TestLast' + String.valueOf(i);
                cs.SuppliedEmail = 'testfirst' + String.valueOf(i) + '.' + 'testlast' + String.valueOf(i) + emailDomain;
            }
            
            testCaseList.add(cs);
        }
        
        return testCaseList;
    }
    
}