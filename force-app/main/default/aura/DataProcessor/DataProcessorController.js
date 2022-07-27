({
    downloadDocument : function(component, event, helper){
       console.log('adsad')
        var sendDataProc = component.get("v.sendData");
        var dataToSend = sendDataProc;
        //invoke vf page js method
        sendDataProc(dataToSend, function(){
            //handle callback
        });
    }
})