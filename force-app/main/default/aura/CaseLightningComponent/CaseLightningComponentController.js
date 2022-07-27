({
  init: function (component, event, helper) {
    component.set("v.loading", true);
  },
  handleSubmit: function (component, event, helper) {
    debugger;
    event.preventDefault();
    var showValidationError = false;
    var vaildationFailReason = "";
    var contactreq = component.find("ContactId");
    var contactreqValue = contactreq.get("v.value");
    var channelreq = component.find("Channel");
    var channelreqValue = channelreq.get("v.value");
   // var Departmentreq = component.find("Department");
   // var DepartmentreqValue = Departmentreq.get("v.value");
    

    if (
      contactreqValue == null ||
      contactreqValue == "" ||
      channelreqValue == null ||
      channelreqValue == "" 
 
     
    ) {
      showValidationError = true;
      vaildationFailReason = "Please fill the required fields!";
    }

    if (!showValidationError) {
      component.set("v.loading", true);
      component.find("CaseRecodForm").submit();
    } else {
      component.find("OppMessage").setError(vaildationFailReason);
      component.set("v.loading", false);
    }
  },
  handleSuccess: function (component, event, helper) {
    debugger;

    var payload = event.getParams().response;
   
      
          var workspaceAPI = component.find("workspace");
         workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
             
             //Opening New Tab
            workspaceAPI.openTab({
                url: '#/sObject/'+payload.id+'/view'
            }).then(function(response) {
                workspaceAPI.focusTab({tabId : payload.id});
            })
            .catch(function(error) {
                console.log(error);
            });
             
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
   
   
      
     
  },
  handleLoad: function (component, event, helper) {
    component.set("v.loading", false);
  },
  handleError: function (component, event, helper) {
    component.set("v.loading", false);
    component.find("OppMessage").setError("Undefined error occured");
  }
});