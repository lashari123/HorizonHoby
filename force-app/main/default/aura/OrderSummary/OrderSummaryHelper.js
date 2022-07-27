({
    checkPageNoList : function(component,event,helper,action){
        
        
        var currentPage = component.get("v.currentPage");
        if((currentPage)>total){
            return
        }
        var total = component.get("v.totalPages")
        
        var pageSize = component.get("v.pageSize");
        var list = [] 
        if(action != 'pre'){
            if((currentPage-1) % 5 == 0){
                for(var i = 0 ; i<5 ; i++){
                    if((i+currentPage)>total){
                        break
                    }
                    
                    list.push(i+currentPage)
                }
            }
            
        }
        else{
            if((currentPage) % 5 == 0){
                var last = currentPage-4 + 5
                for(var i = currentPage-4 ; i<last ; i++){
                    if(i<0){
                        break
                    }
                    
                    list.push(i)
                }
            }
        }
        if(list.length>0)
            component.set("v.totalPagesList",list)
            
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
    paginateData: function(component, event, helper) {
        var data =  component.get("v.data");
        var pageSize = component.get("v.pageSize");
        var totalPages = Math.ceil(data.length/parseInt(pageSize));
        
        debugger
        component.set("v.totalPages", totalPages)
        if(totalPages >5)
        {
            totalPages = 5
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
    getUrlParameter : function(sParam) {
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
    changeTypeInit : function(component, event, helper,itemType) {
        debugger
        
        var item = itemType;
        
        var data = component.get("v.mainData");
        if(item == 'Order History'){
            
            
        }
        else{
            data = data.filter(x=> x.Status == item)
        }
        
        component.set("v.data",data);
        helper.paginateData(component, event, helper);
        helper.setheaderCounterText(component, event, helper);
        
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
            
            
            
            
            
            if(typeof( data[0].Order[selected]) == 'string'){
                
                
                data.sort((a, b)  => {
                    
                    a.Order[selected] = a.Order[selected] == undefined ? '' :a.Order[selected]
                    b.Order[selected] =  b.Order[selected] == undefined ? '' : b.Order[selected]
                    var nameA = a.Order[selected].toUpperCase(); // ignore upper and lowercase
                    var nameB = b.Order[selected].toUpperCase(); // ignore upper and lowercase
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
    }//here
    else  if(typeof( data[0][selected]) == 'number'){
    data.sort( (a, b) => {
    if(asc==false){
    return a[selected] - b[selected];
}
 else{
 
 return b[selected]- a[selected] ;
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