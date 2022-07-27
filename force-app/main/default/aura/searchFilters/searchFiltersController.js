({
	 filter:function (component, event, helper) {
        //event.preventDefault();
         var category = ''//component.find('category').getElements()[0].value
        var keyword = component.find('keyword').getElements()[0].value
        component.set("v.keyword", keyword);
        var manufacturer =''// component.find('manufacture').getElements()[0].value
       var compEvent = component.getEvent("RunFilterEvent");                        
        compEvent.fire();
    }
    
})