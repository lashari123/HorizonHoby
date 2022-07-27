({
    handleValueChange : function(component, event, helper) {
        debugger
        if( component.get('v.isParentCheckAll') == component.get('v.isCheckAll'))
        {
            component.find('checkContact').set('v.value',component.get('v.isCheckAll'))
        }
        var listofItems = component.get('v.SelectedValues');
        var selectedItem = component.get('v.item');  
        var selectedvaluesPrices = component.get('v.SelectedValuePrices');
        if(component.get('v.isCheckAll')){
            if(listofItems.find(x=>x.Id == selectedItem.Id)){
                return
            }
            listofItems.push(selectedItem);
            selectedvaluesPrices += selectedItem.UnitPrice * selectedItem.Quantity
        }
        else{
            var emptyArray = []
            listofItems = emptyArray
            selectedvaluesPrices =0
            
        }
        
        component.set('v.SelectedValues',listofItems);
        component.set('v.SelectedValuePrices',selectedvaluesPrices);
        component.set('v.isLineUpdated',true);

        
    },
    handleNoteValueChange : function(component, event, helper) {
        debugger
        var p = component.get("v.parent");
        p.updateLineItem();
    },
    checkHandler : function(component, event, helper) {
        
        debugger
        var listofItems = component.get('v.SelectedValues');
        var selectedItem = component.get('v.item');  
        var selectedvaluesPrices = component.get('v.SelectedValuePrices');
        
        var SelectedValues = component.get('v.SelectedValues')
        if(event.getSource().get('v.value') == true){
            listofItems.push(selectedItem);
            selectedvaluesPrices += selectedItem.UnitPrice * selectedItem.Quantity
            var data = component.get('v.parent').get('v.data')
            var SelectedValues = component.get('v.SelectedValues')
            
            if(data.length == SelectedValues.length){
                component.set('v.isCheckAll',true)
                component.get('v.parent').find('parentSelectAll').set('v.checked',component.get('v.isCheckAll'))
                   
            }
        }
        else{

           component.set('v.isCheckAll',false)
           component.get('v.parent').find('parentSelectAll').set('v.checked',component.get('v.isCheckAll'))
            const index = listofItems.indexOf(selectedItem);
            if (index > -1) {
                listofItems.splice(index, 1);
                
                selectedvaluesPrices -= selectedItem.UnitPrice.toFixed(2) * selectedItem.Quantity
            }
            if(0 == SelectedValues.length){
                var emptyArray = []
                listofItems = emptyArray
                selectedvaluesPrices =0
            }
        }
        component.set('v.SelectedValues',listofItems);
        component.set('v.SelectedValuePrices',selectedvaluesPrices);
    },
    increment:function (component, event, helper) {
        debugger;
        // var buttonName = event.getSource().get('v.name');
        // var row = buttonName[1];
        // var column = buttonName[0];
        
        var quantity = component.find("inputId");
        
        // if(quantity.getElements()[0].name == buttonName){
        if(!quantity.get('v.value')){
            quantity.set('v.value',0)
        }
        var val = (quantity.get('v.value')) == '' ? 0 :(quantity.get('v.value'))
        var intVal= parseInt(val)
        quantity.set('v.value',intVal + 1)
        
        var item = component.get("v.item");
        component.set("v.item",item);
        
        helper.recalculateValue(component,true)
        var p = component.get("v.parent");
        p.updateLineItem();
        
    },
    decrement:function (component, event, helper) {
        // var buttonName = event.getSource().get('v.name');
        //var row = buttonName[1];
        //var column = buttonName[0];
        
        var quantity = component.find("inputId");
        if(!quantity.get('v.value')){
            quantity.set('v.value',0)
        }
        var item = component.get("v.item");
        
        var val = (quantity.get('v.value')) == '' ? 0 :(quantity.get('v.value'))
        var intVal= parseInt(val)
        if(intVal ==0 )
        {	
            return
        }
        quantity.set('v.value',intVal - 1)
        component.set("v.item",item);
        helper.recalculateValue(component,false)
        var p = component.get("v.parent");
        p.updateLineItem();
    },
    counter : function(component,event,helper){
        event.preventDefault()
        var kc = event.getParam('keyCode')
        
        if(kc == 38 ){
            var a = component.get('c.increment');
            $A.enqueueAction(a);
        }
        else if(kc == 40){
            
            var a = component.get('c.decrement');
            $A.enqueueAction(a);      
        }
    },
    
    
})