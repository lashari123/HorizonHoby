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
    paginateData: function(component, event, helper) {
        var data =  component.get("v.data");
        var pageSize = component.get("v.pageSize");
        var totalPages = Math.ceil(data.length/parseInt(pageSize));
        
        component.set("v.totalPages", totalPages)
        if(totalPages >3)
        {
            totalPages = 3
        }
        
        component.set("v.totalPagesList", Array.from({length: totalPages}, (_, i) => i + 1))
        component.set("v.start",0);
        
        
        
        
        var paginationList = [];
        pageSize = pageSize<data.length ?pageSize:data.length
        component.set("v.end",pageSize-1);
        for(var i=0; i< pageSize; i++)
            
        {
            
            paginationList.push(data[i]);
            
        }
        
        component.set("v.paginationList", paginationList);
        helper.setheaderCounterText(component,event,helper)
        
        
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
                column = cmp.get('v.sortColumns');
                column.forEach(x => x.label = data[x.label]);
                cmp.set('v.sortColumns',column); 
                
                cmp.set('v.DiscontinuedTitle',data[cmp.get('v.DiscontinuedTitle')])
                cmp.set('v.InStockTitle',data[cmp.get('v.InStockTitle')])
                cmp.set('v.exportText',data[cmp.get('v.exportText')])
                cmp.set('v.TotalText',data[cmp.get('v.TotalText')])
                cmp.set('v.selectedItemText',data[cmp.get('v.selectedItemText')])
                cmp.set('v.ClearQuantitiesText',data[cmp.get('v.ClearQuantitiesText')])
                cmp.set('v.addToCartText',data[cmp.get('v.addToCartText')])
            }
        });
        $A.enqueueAction(action);
    },
    setheaderCounterText : function(component,event,helper){
        var data = component.get('v.data')
        var start = component.get('v.start')
        var end = component.get('v.end')
        var locale = $A.get("$Locale.language");
        if(locale == 'de'){
            component.set("v.headerCounterText",'Artikel '+ parseInt(start+1) + ' bis '+parseInt(end+1) +' von '+ data.length)
        }
        else if(locale == 'fr'){
            
            component.set("v.headerCounterText",'Article '+ parseInt(start+1) + ' à '+parseInt(end+1) +' sur '+ data.length)
        }
            else{
                component.set("v.headerCounterText",'Item '+ parseInt(start+1) + ' to '+parseInt(end+1) +' of '+ data.length)
            }
    },
    onSortChange : function(component, event, helper,pos) {
        
        var posChange ='';
        if(pos == '0'){
            posChange = 'asc'
        }
        else if(pos == 'asc'){
            posChange = '0'
        }
        
        
        var selected = component.find("sort").getElements()[0].value;
        event.target.id = selected+'|'+posChange
        //alert(selected)
        var tempSelect = selected
        var asc = posChange == 'asc'
        selected = selected == 'linkName' ? 'ProductCode' : selected;
        selected = selected == 'Description' ? 'ProductName' : selected;
        
        var data = component.get("v.data");
        if(typeof( data[0][selected]) == 'undefined'){
            if(typeof( data[0].pbe.Product2[selected]) == 'string'){
                data.sort((a, b)  => {
                    
                    a.pbe.Product2[selected] = a.pbe.Product2[selected] == undefined ? '' :a.pbe.Product2[selected]
                    b.pbe.Product2[selected] =  b.pbe.Product2[selected] == undefined ? '' : b.pbe.Product2[selected]
                    var nameA = a.pbe.Product2[selected].toUpperCase(); // ignore upper and lowercase
                    var nameB = b.pbe.Product2[selected].toUpperCase(); // ignore upper and lowercase
                    if(asc==false){
                    if (nameA < nameB) {
                    if( selected == "Avail__c"){ return 1}
                          return -1;
                          }
                          if (nameA > nameB) {
                    
                    if( selected== "Avail__c"){ return -1}
                    return 1;
                }
            }
            else{
                if (nameA > nameB) {
                    if( selected == "Avail__c"){ return 1}
                    return -1;
                }
                if (nameA < nameB) {
                    
                    if( selected== "Avail__c"){ return -1}
                    return 1;}
            }
            // names must be equal
            return 0;
        });
    }
    else  if(typeof( data[0].pbe.Product2[selected]) == 'number'){
    data.sort( (a, b) => {
    if(asc==false){
    return a.pbe.Product2[selected] - b.pbe.Product2[selected];
}
 else{
 
    return b.pbe.Product2[selected]- a.pbe.Product2[selected] ;
 }
});
}

}

else if(typeof( data[0][selected]) == 'string'){
    data.sort((a, b)  => {
        
        var nameA = a[selected].toUpperCase(); // ignore upper and lowercase
        var nameB = b[selected].toUpperCase(); // ignore upper and lowercase
        
        if(asc==false){
        if (nameA < nameB) {
        return -1;
    }
              if (nameA > nameB) {
        return 1;
    }
}

    else{
        if (nameA > nameB) {
            return -1;
        }
        if (nameA < nameB) {
            return 1;
        }
    }



// names must be equal
return 0;
});
}
else  if(typeof( data[0][selected]) == 'number'){
    data.sort( (a, b) => {
         if(asc==false){
   return a[selected] - b[selected];
}
 else{
 
    return  b[selected] - a[selected] ;
 }
    });
}
component.set("v.data",data);
helper.paginateData(component, event, helper);
component.set("v.lastSortedColumn",tempSelect)
},
    
})