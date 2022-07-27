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
                    
                    component.set('v.completed',true)
                }
                else{
                    
                }
            }
        });	
        $A.enqueueAction(action);  
    }
})