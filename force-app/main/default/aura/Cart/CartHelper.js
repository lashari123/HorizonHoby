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
        selected = selected == 'Description' ? 'Name' : selected;
        
        
        var data = component.get("v.data");
        if(typeof( data[0][selected]) == 'undefined'){
            if(typeof( data[0].Product2[selected]) == 'string'){
                data.sort((a, b)  => {
                    
                    a.Product2[selected] = a.Product2[selected] == undefined ? '' :a.Product2[selected]
                    b.Product2[selected] =  b.Product2[selected] == undefined ? '' : b.Product2[selected]
                    var nameA = a.Product2[selected].toUpperCase(); // ignore upper and lowercase
                    var nameB = b.Product2[selected].toUpperCase(); // ignore upper and lowercase
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
    else  if(typeof( data[0].Product2[selected]) == 'number'){
    data.sort( (a, b) => {
    if(asc==false){
    return a.Product2[selected] - b.Product2[selected];
}
 else{
 
 return b.Product2[selected]- a.Product2[selected] ;
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
    getTranslation : function(cmp, event, helper){
        
        debugger
        var locale = $A.get("$Locale.language");
        var action = cmp.get("c.getTranslations");
        action.setParams({ langCode : locale});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 	{
                
                var data =  response.getReturnValue();
                
                var column = cmp.get('v.columns');
                column.forEach(x => x.label = data[x.label] != null ? data[x.label] : x.label );
                cmp.set('v.columns',column);
              
              
                
                cmp.set('v.Translations',data)
                cmp.set('v.cartTitle',data[cmp.get('v.cartTitle')])
                cmp.set('v.OrderAlertTitle',data[cmp.get('v.OrderAlertTitle')])
                cmp.set('v.HazardousItems',data[cmp.get('v.HazardousItems')])
                cmp.set('v.MaxQuantities',data[cmp.get('v.MaxQuantities')])
                cmp.set('v.SalesMultiple',data[cmp.get('v.SalesMultiple')])
                cmp.set('v.BackorderDuplicate',data[cmp.get('v.BackorderDuplicate')])
                cmp.set('v.ItemonBackorder',data[cmp.get('v.ItemonBackorder')])
                cmp.set('v.PartsAvailable',data[cmp.get('v.PartsAvailable')])
                cmp.set('v.SmartTechnology',data[cmp.get('v.SmartTechnology')])
            
                cmp.set('v.MovetoExistingOrder',data[cmp.get('v.MovetoExistingOrder')])
                cmp.set('v.MovetoNewOrder',data[cmp.get('v.MovetoNewOrder')])
                cmp.set('v.All',data[cmp.get('v.All')])
                cmp.set('v.Delete',data[cmp.get('v.Delete')])
                cmp.set('v.lineItems',data[cmp.get('v.lineItems')])
            }
        });
        $A.enqueueAction(action);
    },
  
            
})