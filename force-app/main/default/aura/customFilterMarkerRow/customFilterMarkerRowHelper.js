({
    setText : function(component) {
        
        var conditionList = component.get('v.conditionList')
        var ConditionStrings = component.get('v.ConditionStrings')
        var index = component.get('v.index')
        
        ConditionStrings[index] = conditionList.join( ' ')
        component.set('v.ConditionStrings',ConditionStrings)
        
        var Condition = component.get('v.Condition')
        var Object = component.get('v.Object')
        var Field = component.get('v.Field')
        var Operator = component.get('v.Operator')
        var Input = component.get('v.Input')
       
        
        var parseString = [Condition,Object,Field,Operator,Input];
        var parseStringList = component.get('v.parseStringList')
        
        var index = component.get('v.index')
        
        parseStringList[index] = parseString.join(',');
        
     //   component.find("conditionP").getElements()[0].innerText = ConditionStrings[index] 
        
        var parentComponent = component.get("v.parent");                         
        parentComponent.onchangeQuery()
    },
    
    setFieldValues : function(component,selectedObject){
        
        var product = [
            { label: "itemnumber ",name:"product2.productCode"},
            { label: "description ",name:"product2.description"},
            { label: "avg demand ",name:"product2.avgDemand__c"},
            { label: "eta ",name:"product2.eta__c"},
            { label: "promo code ",name:"product2.promocode__c"},
            { label: "Last Update ",name:"product2.LastUpdated__c "},
            { label: "First Appearance",name:"product2.FirstAppearance__c"}];
        var pricebook = [
            { label:"price",name:"pricebookEntry.unitPrice"},
            { label:"promo flag",name:"pricebookEntry.promoFlag__c"}];
        var inventory = [
            { label:"qty",name:"product2.Quantity__c"},
            { label:"last in stock",name:"product2.lastinstock__c"}];
        
        debugger
        if(selectedObject == "Product"){
            component.set("v.FieldNames",product);
        }
        else if(selectedObject == "Inventory"){
            component.set("v.FieldNames",inventory);
        }
            else if(selectedObject == "Pricebook"){
                component.set("v.FieldNames",pricebook);
                
            }
    }
})