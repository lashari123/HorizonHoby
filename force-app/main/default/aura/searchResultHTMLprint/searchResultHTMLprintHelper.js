({
    getUrlParameter : function(cmp,sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
            
            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    },
        getTranslation : function(cmp, event, helper){
        
        debugger
        var locale = $A.get("$Locale.language");
        var action = cmp.get("c.getTranslations");
        action.setParams({ langCode : locale});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var data =  response.getReturnValue();
                
                var column = cmp.get('v.columns');
                column.forEach(x => x.label = data[x.label]);
                cmp.set('v.columns',column);
              
            }
        });
        $A.enqueueAction(action);
    }
    
})