({
    upload: function(component, file, base64Data) {
        console.log('helper',file);
        var action = component.get('c.uploadFile');
        action.setParams({
            // Take current object's opened record. You can set dynamic values here as well
            parentId:component.get('v.caseID'), 
            fileName: file.name,
            base64Data: encodeURIComponent(base64Data),
            contentType: file.type
        });
        var self = this;
        action.setCallback(this, function(response){ 
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var attachId = response.getReturnValue();
                var files = component.get('v.Files')
                if(files[files.length-1].file == file){
                     component.set('v.progress',false)
                    component.set('v.completed',true)
                }
                else{
                
                }
            }
        });	
        $A.enqueueAction(action);  
    },
       MAX_FILE_SIZE: 25000000, //Max file size 4.5 MB 
    CHUNK_SIZE: 2000000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event,file) {
        // start/show the loading spinner   
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            //component.set("v.showLoadingSpinner", false);
            
            component.set('v.progress',false)
            alert('SIZE is greater than 25mb')
            //component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }

        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;

            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });

        objFileReader.readAsDataURL(file);
    },

    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },


    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: component.get("v.caseID"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });

        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    component.set('v.progress',false)
                    component.set('v.completed',true)
                //    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                   // alert('your File is uploaded successfully');
                
                    
                     component.set('v.progress',false)
                    component.set('v.completed',true)
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                
                     component.set('v.progress',false)
                    component.set('v.completed',true)
               // alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                
                     component.set('v.progress',false)
                    component.set('v.completed',true)
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    }
})