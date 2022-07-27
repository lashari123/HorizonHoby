({
    doInit : function(component, event, helper) {
      
        var action = component.get('c.getAccountInfo');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log(JSON.stringify(resp));
                if(resp!=null){
                    console.log('Success: getAccountData');
                    component.set("v.wrapper", resp);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                }
            }
                else{
                    console.log('Failed with state: ' + state);
                }
        });
        
        //send action to be executed
        $A.enqueueAction(action);
    },
    
    deleteImage:function(component, event, helper) {
        debugger
        var id = event.getSource().getLocalId();
        var map =  component.get('v.auraIdDocIdMap')
        var docId = map[id];
        var action = component.get('c.deleteDocument')
        action.setParams({
            // Take current object's opened record. You can set dynamic values here as well
            DocId:docId,
            
        });
        action.setCallback(this, function(response){ 
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                debugger
                 map[id] = ''
                 var fileName = 'File'+ id.replace('dltBtn','')
                 
                 document.getElementById(fileName).innerHTML = ''; 
                 component.set('v.auraIdDocIdMap',map)
                 var index = id.charAt(id.length-1)
                 if(index != '0'){
                     event.getSource().destroy()
                     var uploader  = id.replace('dltBtn','');
                     component.find(uploader).destroy();
                    // document.getElementById(fileName).outerHTML = ''
                 }
                  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Deleted!",
                    "mode": "pester",
                    "type":"success",
                    "duration": 2000,
                    "message": "File has been deleted..."
                });
                toastEvent.fire();
            }
        });
        
        $A.enqueueAction(action); 
    },
    
    remFile: function(component, event, helper) {
        debugger
        var uploadFile = event.currentTarget.files
        
        var files = component.get('v.Files')
        var file = uploadFile[0];
        files = files.filter(x => x.file != file)   
        
        component.set('v.Files', files)
    },
    
    addFile : function(component, event, helper) {
        debugger
        var uploadFile = event.currentTarget.files
        var self = this;
        var file = uploadFile[0]; // getting the first file, loop for multiple files
        const fileSize = file.size / 1024 / 1024; // in MiB
        if (fileSize > 25){
            event.currentTarget.value =''
            alert('File size exceeds 25 MB');
            return
            // $(file).val(''); //for clearing with Jquery
        } else {
            // Proceed further
        }
        var allowed_extensions = new Array("jpg","png","jpeg","pdf","mp4","mov");
        var file_extension = file.name.split('.').pop().toLowerCase(); 
        
        if (!allowed_extensions.includes(file_extension)) {
            //document.getElementById('SbmtBtn').disabled = true
            // 
            //document.getElementById('errorMessage').innerText = 'not right file' 
            event.currentTarget.value =''
            alert('FILE type not supported')
            
            return
        }
        else{
            
            document.getElementById('errorMessage').innerText = '' 
            
            //document.getElementById('SbmtBtn').disabled = false
            
        }
        /*   var reader = new FileReader();
        reader.onload =  $A.getCallback(function() {
            var dataURL = reader.result;
            var base64 = 'base64,';
            var dataStart = dataURL.indexOf(base64) + base64.length;
            dataURL= dataURL.substring(dataStart);
            var fileData = {'file':file,'dataURL':dataURL}
            var files = component.get('v.Files')
            files.push(fileData)
            component.set('v.Files', files)
            // helper.upload(component, file, dataURL)
        });
        reader.readAsDataURL(file);*/
        var files = component.get('v.Files')
        files.push(file)
        
        component.set('v.Files', files)
        
    },
    
    init : function(component, event, helper) {
        var j$ = jQuery.noConflict(); //To avoid conflict with any standard variables
        j$(document).ready(function() {
            debugger
            
            j$('#addMore').click(function(){
                debugger
                var T =   j$('#uploadHere')
                var ind = component.get('v.Inputindex')
                var idstr = 'inputAppend' +'' +ind
                component.set('v.Inputindex',ind+1)
                T.append(` <span class="sub-title"></span>
                         <input class= `+ idstr +`  type="file" placeholder="CHOOSE" onchange="{!c.addFile}" accept="image/*"/>
                         <button type="button" title="Settings" style="margin:-3px" name=`+idstr+` id="deleteImage" class="deleteImage slds-button slds-button_icon slds-button_icon-border-filled" data-aura-rendered-by="95:2;a"><lightning-primitive-icon data-aura-rendered-by="96:2;a"><svg focusable="false" data-key="delete" aria-hidden="true" viewBox="0 0 52 52" class="slds-button__icon"><g><g><path d="M45.5 10H33V6c0-2.2-1.8-4-4-4h-6c-2.2 0-4 1.8-4 4v4H6.5c-.8 0-1.5.7-1.5 1.5v3c0 .8.7 1.5 1.5 1.5h39c.8 0 1.5-.7 1.5-1.5v-3c0-.8-.7-1.5-1.5-1.5zM23 7c0-.6.4-1 1-1h4c.6 0 1 .4 1 1v3h-6V7zM41.5 20h-31c-.8 0-1.5.7-1.5 1.5V45c0 2.8 2.2 5 5 5h24c2.8 0 5-2.2 5-5V21.5c0-.8-.7-1.5-1.5-1.5zM23 42c0 .6-.4 1-1 1h-2c-.6 0-1-.4-1-1V28c0-.6.4-1 1-1h2c.6 0 1 .4 1 1v14zm10 0c0 .6-.4 1-1 1h-2c-.6 0-1-.4-1-1V28c0-.6.4-1 1-1h2c.6 0 1 .4 1 1v14z"></path></g></g></svg></lightning-primitive-icon><span class="slds-assistive-text" data-aura-rendered-by="98:2;a">delete</span></button>
                         <span class="errorMessage" style="color:red"></span>`)
                         j$('.inputAppend' +'' +ind).change(function(event){
                    debugger
                    var uploadFile = event.currentTarget.files
                    var self = this;
                    var file = uploadFile[0]; // getting the first file, loop for multiple files
                    
                    var allowed_extensions = new Array("jpg","png","jpeg","pdf","mp4","mov");
                    var file_extension = file.name.split('.').pop().toLowerCase(); 
                    
                    if (!allowed_extensions.includes(file_extension)) {
                        // document.getElementById('SbmtBtn').disabled = true
                        // var i = j$(event.currentTarget).siblings().length -1
                        // j$(event.currentTarget).siblings()[i].innerText = 'not right file'
                        event.currentTarget.value =''
                        alert('FILE type not supported')
                        
                        return
                    }
                    else{
                        var i = j$(event.currentTarget).siblings().length -1
                        j$(event.currentTarget).siblings()[i].innerText = ''
                        // document.getElementById('SbmtBtn').disabled = false
                        
                    }
                    /* var reader = new FileReader();
                    reader.onload =  $A.getCallback(function() {
                        var dataURL = reader.result;
                        var base64 = 'base64,';
                        var dataStart = dataURL.indexOf(base64) + base64.length;
                        dataURL= dataURL.substring(dataStart);
                        var fileData = {'file':file,'dataURL':dataURL}
                        var files = component.get('v.Files')
                        files.push(fileData)
                        component.set('v.Files', files)
                        // helper.upload(component, file, dataURL)
                    });
                    reader.readAsDataURL(file);*/
                    files.push(file)
                    component.set('v.Files', files) 
                })
                j$('.inputAppend' +'' +ind).click(function(event){
                    debugger
                    var uploadFile = event.currentTarget.files
                    
                    var files = component.get('v.Files')
                    var file = uploadFile[0];
                    files = files.filter(x => x.file != file)   
                    
                    component.set('v.Files', files)
                });
                j$('.deleteImage').click(function(event){
                    
                    
                    var uploadFile =   j$('.'+event.target.name)[0].files
                    var files = component.get('v.Files')
                    var file = uploadFile[0];
                    files = files.filter(x => x.file != file)   
                    
                    component.set('v.Files', files) 
                    
                    event.currentTarget.outerHTML = ''              
                    j$('.'+event.target.name)[0].outerHTML =''
                    j$('.'+event.target.name)[0].value = ''
                })
                
            })
            
            
        });
    },
    
    submit:function(component, event, helper) {
        debugger
        var files = component.get('v.Files')
        /* files.forEach(function(item) {
            
            var allowed_extensions = new Array("jpg","png","jpeg");
            var file_extension = item.file.name.split('.').pop().toLowerCase(); 
            
            if (!allowed_extensions.includes(file_extension)) {
                alert('FILE type not supported ')
                isValid = false;
                return
            }
        });*/
        var action = component.get('c.submitCases');
        action.setParams({
            // Take current object's opened record. You can set dynamic values here as well
            Subject:document.getElementById('subject').value,
            id:  component.get('v.caseID')

        });
        var self = this;
        action.setCallback(this, function(response){ 
            
            
            component.set('v.progress',true)
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger
                console.log('response.getReturnValue(): '+response.getReturnValue())
                component.set('v.caseID',response.getReturnValue().Id)
                component.set('v.caseNumber',response.getReturnValue().CaseNumber)
                component.set('v.progress',false)
                
                files.forEach(function(item)
                              {
                                  
                                  //helper.upload(component, item.file, item.dataURL)
                              //    helper.uploadHelper(component, event,item);
                              },this);
                
                if(files.length==0)
                {  component.set('v.progress',false)
                
                component.set('v.completed',true)
                //   location.reload();
                }
            }
        });	
        $A.enqueueAction(action);  
        
        
    },
    
    handleUploadFinished: function (component, event) {
        // Get the list of uploaded files
        debugger
        var uploadedFiles = event.getParam("files");
        ///alert("Files uploaded : " + uploadedFiles.length);
        var id  = 'File'+event.getSource().getLocalId()
        var dlid  = 'dltBtn'+event.getSource().getLocalId()
        document.getElementById(id).innerHTML = uploadedFiles[0].name;
        var map = component.get('v.auraIdDocIdMap')
        map[dlid]= uploadedFiles[0].documentId
        component.set('v.auraIdDocIdMap',map)
        //component.set('v.fileName',uploadedFiles[0].name)
        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
    },
  
    typeChangeHandler : function(component, event, helper){
        
        var isGI =event.target.value != 'Technical Question' ;
        component.set('v.isGI',isGI)
        if(event.target.value == 'Select' || isGI == false){
            
            document.getElementById('SbmtBtn').disabled = true
          
        }
        else{
            
            document.getElementById('SbmtBtn').disabled = false
              if( component.get('v.caseID')==''){
                var action = component.get('c.submitCases');
                action.setParams({
                    // Take current object's opened record. You can set dynamic values here as well
                    Subject:document.getElementById('subject').value,
                    id:  component.get('v.caseID')
                });
                var self = this;
                action.setCallback(this, function(response){ 
                    
                    
                   // component.set('v.progress',true)
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        
                        component.set('v.showFile',true)
                        debugger
                        console.log('response.getReturnValue(): '+response.getReturnValue())
                        component.set('v.caseID',response.getReturnValue().Id)
                        component.set('v.caseNumber',response.getReturnValue().CaseNumber)
                    }
                    
                });	
                $A.enqueueAction(action);  
            }
        }
        
        
        
    },
  
    catChangeHandler:function(component, event, helper){
        
        if(event.target.value == 'Select'){
            
            document.getElementById('SbmtBtn').disabled = true
          
        }
        else{
            
            document.getElementById('SbmtBtn').disabled = false
              if( component.get('v.caseID')==''){
                var action = component.get('c.submitCases');
                action.setParams({
                    // Take current object's opened record. You can set dynamic values here as well
                    Subject:document.getElementById('subject').value,
                    id:  component.get('v.caseID')

                });
                var self = this;
                action.setCallback(this, function(response){ 
                    
                  //  component.set('v.progress',true)
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        debugger
                        console.log('response.getReturnValue(): '+response.getReturnValue())
                        component.set('v.caseID',response.getReturnValue().Id)
                        component.set('v.caseNumber',response.getReturnValue().CaseNumber)
                    }
                    
                });	
                $A.enqueueAction(action);  
            }
        }
    },
    
    refresh : function(component, event, helper){
        location.reload();
        
    } ,
    
    addRow:function (component, event) {
        var ind = component.get('v.Inputindex')
        var idstr = 'inputAppend' +'' +ind
        component.set('v.Inputindex',ind+1)
          $A.createComponent(
            "lightning:fileUpload",
            {
                "aura:id": idstr,
                "label": "",
                'name':"fileUploader",
                'multiple':"false"  ,
                'variant':"label-hidden",
                'accept':component.get('v.filetype'),
                'disabled' : !component.get('v.showFile'),
                'recordId':component.get('v.caseID'),
                'onuploadfinished': component.getReference("c.handleUploadFinished")

            },
            function(newButton, status, errorMessage){
                //Add the new button to the body arraycomponent
                //
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newButton);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );

         $A.createComponent(
            "lightning:buttonIcon", {
                "disabled" :!component.get('v.showFile'),
                "aura:id" : 'dltBtn'+idstr,
                'iconName':"utility:delete",  "variant":"border-filled" ,
                "alternativeText":"delete", 
                "onclick":component.getReference("c.deleteImage"),
                'title':"Settings" },
             
            
            function(newButton, status, errorMessage){
                //Add the new button to the body arraycomponent
                //
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newButton);
                    //body.push(' <span id="FileinputAppend0" style="color:red">{!v.fileName}</span>');
                    component.set("v.body", body);
                   
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );
           $A.createComponent(
            "span", {
                
                "id" : 'File'+idstr,
            },
             
            
            function(newButton, status, errorMessage){
                //Add the new button to the body arraycomponent
                //
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newButton);
                    //body.push(' <span id="FileinputAppend0" style="color:red">{!v.fileName}</span>');
                    component.set("v.body", body);
                   
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );
    },
})