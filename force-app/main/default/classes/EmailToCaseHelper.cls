public with sharing class EmailToCaseHelper {
  public static List<EmailToCase__c> unwrapList(
    List<EmailToCaseWrapper> wrappedlist
  ) {
    List<EmailToCase__c> unwrapped = new List<EmailToCase__c>();
    for (EmailToCaseWrapper e2cw : wrappedlist) {
      unwrapped.add(e2cw.e2c);
    }
    return unwrapped;
  }

  public static List<EmailToCase__c> sortRules(
    List<EmailToCase__c> unsortedList
  ) {
    List<EmailToCaseWrapper> wrappedList = new List<EmailToCaseWrapper>();
    List<EmailToCase__c> unwrappedList = new List<EmailToCase__c>();
    try {
      wrappedList = wrapList(unsortedList);
      wrappedList.sort();
      unwrappedList = unwrapList(wrappedList);
    } catch (Exception ex) {
      ExceptionLogger.LogException(ex);
    }
    return unwrappedList;
  }

  public static List<EmailToCase__c> getRules() {
    return EmailToCase__c.getall().values();
  }

  public static List<EmailToCase__c> getSortedRules() {
    return sortRules(getRules());
  }

  public static List<EmailToCaseWrapper> wrapList(
    List<EmailToCase__c> unwrappedList
  ) {
    List<EmailToCaseWrapper> wrappedList = new List<EmailToCaseWrapper>();
      for (EmailToCase__c unwrapped : unwrappedList) {
        wrappedList.add(new EmailToCaseWrapper(unwrapped));
      
    }
    return wrappedList;
  }

  public static Boolean checkRule(
    String value,
    String ruleValue,
    String ruleOperator
  ) {
    Boolean match = false;
      ruleOperator = ruleOperator == null ? '==' : ruleOperator;
      if (ruleValue == '') {
        match = true;
      } else if (ruleOperator.toLowerCase() == 'contains') {
        match = (((String) value.replace('@', ''))
          .contains(ruleValue.replace('@', '')));
      } else if (ruleOperator.toLowerCase() == '!contains') {
        match = (!((String) value.replace('@', ''))
          .contains(ruleValue.replace('@', '')));
      } else if (ruleOperator == '==') {
        match = (value == ruleValue);
      } else if (ruleOperator == '!=') {
        match = (value != ruleValue);
      }
    return match;
  }

  public static Id getGroupIdByName(String groupName) {
      List<Group> groups = [SELECT Id FROM Group WHERE Name = :groupName];
      if (groups.size() <= 0) {
        return null;
      }
      Group grp = groups[0];
      Id grpId = grp.Id;
      return grpId;
  }

  public static Case processEmailToCase(EmailMessage email, Case caseToUpdate) {
    try {
      List<EmailToCase__c> SortedRules = getSortedRules();
      Integer i = 0;
      while (i < SortedRules.size()) {
        // for (EmailToCase__c rule:rules){
        EmailToCase__c rule = SortedRules[i];
        //check from address
        if (rule.Enabled__c) {
          Integer checked = 0;
          Integer passed = 0;

          //from address check
          if (rule.From_Address__c != null && rule.From_Address__c != '') {
            checked++;
            if (
              checkRule(
                email.FromAddress,
                rule.From_Address__c,
                rule.From_Address_Operator__c
              )
            ) {
              passed++;
            }
          }
          //to address check
          if (rule.To_Address__c != null && rule.To_Address__c != '') {
            checked++;
            if (
              checkRule(
                email.ToAddress,
                rule.To_Address__c,
                rule.To_Address_Operator__c
              )
            ) {
              passed++;
            }
          }
          //subject check
          if (rule.Subject__c != null && rule.Subject__c != '') {
            System.debug(rule);
            checked++;
            if (
              checkRule(
                email.Subject,
                rule.Subject__c,
                rule.Subject_Operator__c
              )
            ) {
              passed++;
            }
          }
          if (checked > 0 && checked == passed) {
            caseToUpdate.Channel__c = rule.Then_Channel__c;
            caseToUpdate.Brand_List__c = rule.Then_Brand_List__c;
            caseToUpdate.Origin = rule.Then_Case_Origin__c;
            caseToUpdate.Case_Sub_origin__c = rule.Then_Case_Sub_Origin__c;
            caseToUpdate.Category_List__c = rule.Then_Category_List__c;
            caseToUpdate.Department__c = rule.Then_Department__c;
            caseToUpdate.Reason = rule.Then_Case_Reason__c;
            if (rule.Then_Status__c == null || rule.Then_Status__c == '') {
              caseToUpdate.Status = 'New';
            } else {
              caseToUpdate.Status = rule.Then_Status__c;
              if (caseToUpdate.Status == 'Closed') {
                caseToUpdate.Reason = 'Other';
                caseToUpdate.Issue__c = 'Other';
                caseToUpdate.Fix__c = 'Other';
                caseToUpdate.PS_Fix_Detail__c = 'Other';
                caseToUpdate.Auto_Closed__c = true;
              }
            }

            Id ownerId = getGroupIdByName(rule.Then_Owner__c);
            if (ownerId != null) {
              caseToUpdate.OwnerId = ownerId;
            } else {
              System.debug(
                'group id not found. check that group ' +
                rule.Then_Owner__c +
                ' exists'
              );
            }
            caseToUpdate.Purchase_Method__c = rule.Then_Purchase_Method__c;
            i = SortedRules.size();
          }
        }
        i++;
      }
    } catch (Exception ex) {
      ExceptionLogger.LogException(ex);
    }
    return caseToUpdate;
  }
}