({
    init : function(component, event, helper) {
        var recordID = component.get('v.recordId')
        if(recordID){
            var action = component.get("c.getParsingValue");
            action.setParams({
                'filterId': recordID
            });
            
            action.setCallback(this, function(response) {
                let state = response.getState();
                var rows = component.get('v.rows')
                if (state === "SUCCESS") {
                    if(response.getReturnValue().isEditable__c == false){
                        component.set("v.isEditable",false)
                         var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Alert! Unchangeable record",
                        "mode": "demisible",
                        "type":"Info",
                        "message": "You can not edit this record. Contact your administrator."
                    });
                    toastEvent.fire();
                    }
                    var parseString = response.getReturnValue().parsingString__c.split('|')
                    for(var i =1; i< parseString.length ; i++){
                        
                        rows.push(i)
                    }
                    
                    component.set('v.rows',rows)
                    component.set('v.parseStringList',parseString)
                    component.set('v.FilterName',response.getReturnValue().Name)
                    
                    var parseStringList = component.get('v.parseStringList')
                    
                    component.set('v.show',true)
                }
            });
            
            $A.enqueueAction(action); 
            
        }
        else{
            component.set('v.show',true)
        }
        component.set('v.columns', [
            //    {label: 'imageLink', fieldName: 'PrimaryImageLink', type: 'text'},
            
            {label: 'Item',  fieldName: 'ProductName' ,type:'text' , required: true },
            { label: 'QTY', fieldName: 'Quantity__c', type: 'number'},
            {label: 'Description', fieldName: 'Description', type: 'text'},
            {label: 'Retail', fieldName: 'UnitPrice', type: 'currency', typeAttributes: { currencyCode: 'EUR'},  typeAttributes: { required: true }, } ,
            {label: 'ETA', fieldName: 'ETA__c', type: 'text'},
            {label: "Promo Code",fieldName:"PromoCode__c", type: 'text'},
            {label:"promo flag",fieldName:"promoFlag__c", type: 'text'},
            {label: 'Last in Stock', fieldName: 'LastInStock__c', type: 'text'},
            {label: 'First Appearance', fieldName: 'FirstAppearance__c', type: 'text'},
            {label: 'Last Updated', fieldName: 'lastUpdated__c', type: 'text'}
            
            
            
            
        ]);
    },
    /*
     * GetFields : function(component, event, helper) {
        
        var product = [
            { label: "itemnumber ",Name:"itemNumber"},
            { label: "description ",Name:"description"},
            { label: "avg demand ",Name:"avgDemand__c"},
            { label: "eta ",Name:"eta__c"},
            { label: "promo code ",Name:"promoCode__c"}];
        var pricebook = ["price","promo flag"];
        var inventory = ["qty","lastinstock"];
        debugger
        var selectedObject = event.getSource().get("v.value");
        if(selectedObject == "Product"){
            component.set("v.FieldNames",product);
            component.set("v.showFields",true);
        }
        else if(selectedObject == "Inventory"){
            component.set("v.FieldNames",inventory);
            component.set("v.showFields",true);
        }
            else if(selectedObject == "Pricebook"){
                component.set("v.FieldNames",pricebook);
                component.set("v.showFields",true);
            }
        
        
    },
    */
    refreshData : function(component,event,helper){
        var ConditionString = component.get('v.ConditionStrings')
        // component.find("conditionP").getElements()[0].innerText = ConditionString.join(' ')
        var action = component.get("c.getFilteredData");
        action.setParams({
            'QueryFilter': ConditionString.join(' ')});
        
        action.setCallback(this, function(response) {
            var data = response.getReturnValue();
            if(data != null){
                data.forEach(function(x){
                    x.ProductName = x.Product2.Name;
                    x.Description = x.Product2.Description;
                    x.ETA__c = x.Product2.ETA__c;
                    x.LastInStock__c = new Date(x.Product2.LastInStock__c).toLocaleDateString("en-UK").replaceAll('/', '-');
                    x.PromoCode__c =  x.Product2.PromoCode__c;
                    x.Quantity__c  = x.Product2.Quantity__c 
                    x.FirstAppearance__c  =  new Date(x.Product2.FirstAppearance__c).toLocaleDateString("en-UK").replaceAll('/', '-');
                    x.lastUpdated__c  = new Date(x.Product2.LastUpdated__c).toLocaleDateString("en-UK").replaceAll('/', '-'); 
                },this)
            }
            component.set("v.data",data);
            
        });
        
        $A.enqueueAction(action); 
    },
    
    add : function(component,event,helper){
        var rows = component.get('v.rows')
        rows.push(rows.length)
        component.set('v.rows',rows)
        
        var ConditionString = component.get('v.ConditionStrings')
        ConditionString.push('')
        component.set('v.ConditionStrings',ConditionString)
        
    },
    
    Submit : function(component,event,helper){
        var recordID = component.get('v.recordId')
        var parseStringList = component.get('v.parseStringList')
        var parseString = parseStringList.join('|')
        
        var ConditionString = component.get('v.ConditionStrings')
        var FilterName = component.get('v.FilterName')
        var action = component.get("c.saveFilter");
        action.setParams({'Name':FilterName,
                          'QueryFilter': ConditionString.join(' '),
                          'parseString': parseString,
                          'recordID' : recordID
                         });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'error'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Unable to save!",
                        "mode": "pester",
                        "type":"error",
                        "duration": 2000,
                        "message": "You can not edit this record. Contact your administrator."
                    });
                    toastEvent.fire();
                    return;
                }
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": response.getReturnValue(),
                    "slideDevName": "related"
                });
                navEvt.fire();
                
            }
        } );
        
        $A.enqueueAction(action); 
    }
})