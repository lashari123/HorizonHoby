@isTest
public class languagecontroll_unitTest {

   static testmethod  void changeLanguage() {
       
     
      list<user> userList =new list<user>();
        User u = [select LanguageLocaleKey,username  from User where Id = :UserInfo.getUserId()];
        u.LanguageLocaleKey = 'en_US';
        u.Id = UserInfo.getUserId();
        u.LastName = 'LIVESTON';
        u.FirstName ='JASON';
        u.Username  = 'jason.liveston@najammm.com';
        update u;
       
       LanguageController.changeLanguage('u');
    }
   
 }