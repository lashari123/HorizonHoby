({
	recalculateValue : function(component,isIncrement) {
        
        debugger
        var listofItems = component.get('v.SelectedValues');
        var selectedItem = component.get('v.item');  
        var selectedvaluesPrices = component.get('v.SelectedValuePrices');
        
        const index = listofItems.indexOf(selectedItem);
        if (index > -1) {

            if (isIncrement){
                selectedvaluesPrices += selectedItem.UnitPrice 
            }
            else{
                selectedvaluesPrices -= selectedItem.UnitPrice 
            }
        }
        component.set('v.isLineUpdated',true);
        component.set('v.SelectedValues',listofItems);
        component.set('v.SelectedValuePrices',selectedvaluesPrices);
        var quantity = component.find("inputId").get("v.value");
        if(quantity == 0 )
        {
            var zeroArray = component.get('v.ZeroValue')
            zeroArray.push(selectedItem);
            component.set('v.ZeroValue',zeroArray)
            component.set('v.showDeleteAlert',true)
        }
    }
})