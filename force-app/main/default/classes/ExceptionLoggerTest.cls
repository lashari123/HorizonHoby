@isTest
public class ExceptionLoggerTest {
  @isTest
  static void ExceptionOccuringInTryCatchGetsLogged() {
    //Arrange
    Case c = new Case();
    //Act
    //force an exception to occur
    try {
      c.Id = '3';
      insert c;
    } catch (Exception ex) {
      System.debug(ex);
      ExceptionLogger.LogException(ex);
      //Assert
      List<Exception__c> exceptions = [
        SELECT
          Id,
          OwnerId,
          IsDeleted,
          Name,
          RecordTypeId,
          CreatedDate,
          CreatedById,
          LastModifiedDate,
          LastModifiedById,
          SystemModstamp,
          LastActivityDate,
          LastViewedDate,
          LastReferencedDate,
          Class_Namespace__c,
          Class_Is_Valid__c,
          Class_Last_Modified_By__c,
          Class_Modified_Date__c,
          Class_Status__c,
          Class__c,
          Line_Number__c,
          Message__c,
          Method__c,
          Type_Name__c,
          Class_API_Version__c
        FROM Exception__c
      ];
      System.assert(exceptions.size() == 1, 'Size should be 1.');
      Exception expected = ex;
      Exception__c actual = exceptions[0];
      System.assert(
        expected.getStackTraceString().indexOf(actual.Class__c) >= 0,
        'Class name should be in exception'
      );
      System.assert(
        expected.getStackTraceString().indexOf(actual.Method__c) >= 0,
        'Method name should be in exception'
      );
      System.assert(
        expected.getStackTraceString().indexOf(actual.Class__c) >= 0,
        'Class name should be in exception'
      );
      System.assertEquals(
        String.valueOf(expected.getLineNumber()),
        actual.Line_Number__c,
        'Line Number should match'
      );
    }
  }
}