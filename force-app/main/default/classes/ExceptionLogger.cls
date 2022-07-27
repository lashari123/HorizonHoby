public class ExceptionLogger {
  public static void LogException(Exception ex) {
    Exception__c error = new Exception__c();
    String stacktracestring = ex.getStackTraceString();
    String[] classmethod = stacktracestring.split(':')[0]
      .replace('Class.', '')
      .split('\\.');
    String classname = classmethod[0];
    String method = classmethod[1];
    ApexClass abc = [
      SELECT
        ApiVersion,
        Body,
        BodyCrc,
        CreatedById,
        CreatedDate,
        Id,
        IsValid,
        LastModifiedById,
        LastModifiedDate,
        LengthWithoutComments,
        Name,
        NamespacePrefix,
        Status,
        SystemModstamp
      FROM ApexClass
      WHERE Name = :classname
    ];
    System.debug(abc.Name);
    System.debug(abc.LastModifiedDate);
    error.Class__c = classname;
    error.Method__c = method;
    error.Message__c = ex.getMessage();
    error.Line_Number__c = String.valueOf(ex.getLineNumber());
    error.Type_Name__c = ex.getTypeName();
    error.Class_Last_Modified_By__c = abc.LastModifiedById;
    error.Class_Modified_Date__c = abc.LastModifiedDate;
    error.Class_API_Version__c = abc.ApiVersion;
    error.Class_Namespace__c = abc.NamespacePrefix;
    error.Class_Status__c = abc.Status;
    error.Class_Is_Valid__c = abc.IsValid;
    System.debug(error);

    insert error;
  }
}