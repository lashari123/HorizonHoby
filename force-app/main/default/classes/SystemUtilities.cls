public class SystemUtilities 
{
	public static Map<String, String> alreadyExecuted = new Map<String, String>();
   
    public static Map<Id, Group> queueMap;
    public static Map<String, Group> queueMapByName;
    public static Map<Id, QueueSobject> queueSobjects;
    public static Map<Id, RecordType> recordTypeMap;
    public static Map<String, RecordType> recordTypeMapByName;
    
    public static Map<Id, User> userMap;

    public static void getUserInfo(Set<Id> userIds)
    {
        if(userMap == null || userMap.isEmpty())
        {
            userMap = new Map<Id, User>();
            List<User> userList = userQuery(userIds);
            for(User u : userList)
            {
                userMap.put(u.Id, u);
            }
        }
        else
        {
            Set<Id> missingIds = new Set<Id>();
            for(Id recordId : userIds)
            {
                if(!userMap.containsKey(recordId))
                {
                    missingIds.add(recordId);
                }
            }
            
            if(!missingIds.isEmpty())
            {
                List<User> userList = userQuery(missingIds);
                for(User u : userList)
                {
                    userMap.put(u.Id, u);
                }
            }
        }
    }
    
    public static Boolean isAlreadyExecuted(String methodName)
    {
        Boolean executed = false;
        
        if(alreadyExecuted.containsKey(methodName))
        {
            executed = true;
        }
        
        return executed;
    }
    
    public static void setExecuted(String methodName)
    {
        alreadyExecuted.put(methodName, methodName);
    }
    
    public static void resetExecuted(String methodName)
    {
        alreadyExecuted.remove(methodName);
    }
    
	public static void resetAllExecuted()
    {
        alreadyExecuted.clear();
    }


	public static void getQueues()
    {
        if(queueMap == null)
        {
            queueMapByName = new Map<String, Group>();
            queueMap = new Map<Id, Group>([SELECT Id, Name, DeveloperName, Type, Email FROM Group WHERE Type = 'Queue']);
            for(Group q : queueMap.values())
            {
                queueMapByName.put(q.Name, q);
            }
        }
    }

    public static void getQueueSobjects()
    {
        if(queueSobjects == null)
        {
            queueSobjects = new Map<Id, QueueSobject>([SELECT Id, QueueId, SobjectType FROM QueueSobject]);
        }
    }
    
    public static void getAllRecordTypes()
    {
        if(recordTypeMap == null || recordTypeMapByName == null)
        {
            recordTypeMap = new Map<Id, RecordType>();
            recordTypeMapByName = new Map<String, RecordType>();
            
            List<RecordType> recordTypeList = new List<RecordType>([SELECT Id, Name, SobjectType, DeveloperName, IsActive FROM RecordType WHERE IsActive = true]);
            for(RecordType rt : recordTypeList)
            {
                recordTypeMap.put(rt.Id, rt);
                recordTypeMapByName.put(rt.SobjectType + '_' + rt.DeveloperName, rt);
            }
        }
    }
    
    public static List<Case> caseQuery(Set<Id> caseIds)
    {
		String queryString = 'SELECT Id, Status, ClosedDate, IsClosed, Auto_Close_Date__c, Sub_Channel__c, Department__c, ' +
                                    'SuppliedName, SuppliedEmail, First_Name__c, Last_Name__c, Customer_Last_Response_Date_Time__c, OwnerId ' +
                               'FROM Case ' +
                              'WHERE Id IN :caseIds';

        return database.query(queryString);
    }
    
   private static List<User> userQuery(Set<Id> userIds)
   {
       String queryString = 'SELECT Id, CompanyName, IsActive, Email, ManagerId, Name, ProfileId, UserRoleId, Title, Username, Data_Load_Mode__c ' +
                            'FROM User ' +
                           'WHERE Id IN :userIds ' +
                             'AND IsActive = true';

       return database.query(queryString);

    }
    
    public static String escapeHtmlCharacters(String value)
    {
        value = value.replace(' ', '%20');
        value = value.replace('$', '%24');
        value = value.replace('&', '%26');
        value = value.replace('`', '%60');
        value = value.replace(':', '%3A');
        value = value.replace('<', '%3C');
        value = value.replace('>', '%3E');
        value = value.replace('[', '%5B');
        value = value.replace(']', '%5D');
        value = value.replace('{', '%7B');
        value = value.replace('}', '%7D');
        //value = value.replace('"', '%22');
        value = value.replace('+', '%2B');
        value = value.replace('#', '%23');
        value = value.replace('%', '%25');
        value = value.replace('@', '%40');
        value = value.replace('/', '%2F');
        value = value.replace(';', '%3B');
        value = value.replace('=', '%3D');
        value = value.replace('?', '%3F');
        value = value.replace('\\', '%5C');
        value = value.replace('^', '%5E');
        value = value.replace('|', '%7C');
        value = value.replace('~', '%7E');
        //value = value.replace(''', '%27');
        value = value.replace(',', '%2C');
        
        return value;
    }

}