({
	totalCalculator : function(component) {
		
        var dataSelected = component.get("v.SelectedValues");
        var total = 0;
        dataSelected.forEach(x=>{ total += x.Quantity*x.dealer });
        component.set("v.totalAmountSelected",total);
        var parentComponent = component.get("v.parent");                         
		parentComponent.onchangeData()
	}
})