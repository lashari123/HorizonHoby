public class CaseOwnerChangePoller 
{
    @AuraEnabled
    public static String getCurrentUser()
    {
        return UserInfo.getName();
    }
    
    @AuraEnabled
    public static String getCaseOwner(String recordId)
    {
        //Case cs = [SELECT Id, OwnerId, Owner.Name FROM Case WHERE Id = :(Id)recordId];
        List<Case> cs = new List<Case>([SELECT Id, OwnerId, Owner.Name FROM Case WHERE Id = :(Id)recordId]);
        
        if(cs.isEmpty())
        {
            return '';
        }
        else
        {
        	return cs[0].OwnerId + '_' + cs[0].Owner.Name;
        }
    }
    
    @AuraEnabled
    public static String changeCaseOwner(String recordId)
    {
        System.debug(recordId);
        List<Profile> profileList = new List<Profile>([SELECT Id, Name FROM Profile]);
        
        Map<Id, Profile> profileMap = new Map<Id, Profile>();
        for(Profile p : profileList)
        {
            if(p.Name == 'European Support' || p.Name == 'US Customer Support' || p.Name == 'US Product Support')
            {
                profileMap.put(p.Id, p);
            }
        }
        
        List<Case> cs = new List<Case>([SELECT Id, OwnerId, Owner.Name, IsClosed FROM Case WHERE Id = :(Id)recordId]);
        
        String ownerName = '';
        if(cs.isEmpty()) 
        {
             return ownerName;
        }
        
        ownerName = cs[0].Owner.Name;
        String ownerId = cs[0].OwnerId;
        if(ownerId.left(3) == '00G'
           && cs[0].IsClosed == false
           && profileMap.containsKey(UserInfo.getProfileId()))
        {
            cs[0].OwnerId = UserInfo.getUserId();
            ownerName = cs[0].OwnerId + '_' + UserInfo.getName();
            update cs;
            System.debug(cs[0].OwnerId);
        }
        else
        {
            ownerName = cs[0].OwnerId + '_' + cs[0].Owner.Name;
        }
        
        return ownerName;
    }
    
}