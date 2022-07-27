({
    onEditCell : function(component, event, helper) {
        component.set("v.EditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("inputId").focus();
        }, 100);
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
    
    onChange : function(component,event,helper){ 
        // if picklist value change,
        // then show save and cancel button by set attribute to true
        debugger
        
        //  if (event.getParams().keyCode == 13){
        component.set("v.EditMode", false);
        var x = component.get("v.SelectedValues");
        var item = component.get("v.item");
        item.Quantity= parseInt(item.Quantity)
        
        if(item.Quantity <0)
        {
            component.find("inputId").set('v.value',item.Quantity*-1);
        }
        if(isNaN(item.Quantity)){
            item.Quantity=''
        }
        if(x.filter(x=> x.product2Id == item.product2Id).length >0 ){
            if(item.Quantity ==0)
            {
                x.splice(x.findIndex(v => v.product2Id === item.product2Id), 1);
                component.set("v.SelectedValues",x);
            }
            helper.totalCalculator(component); 
            return;
        }
        if(item.Quantity> 0){ 
            x.push(item);
        }
        
        
        component.set("v.SelectedValues",x);
        component.set("v.item",item);
        
        helper.totalCalculator(component);
        // }    
    }, 
    
    closeBox : function (component, event, helper) {
        if(event.getSource().get('v.name') == ''){
            
        }
        // on focus out, close the input section by setting the 'ratingEditMode' att. as false
        component.set("v.EditMode", false); 
        var x = component.get("v.SelectedValues");
        var item = parseInt(valcomponent.get("v.item")); 
        if(item.Quantity> 0){ 
            x.push(item);
        }
        
        component.set("v.SelectedValues",x);
        helper.totalCalculator(component);
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
        // quantity.getElements()[0].value = intVal + 1;
        
        // }
        component.set("v.EditMode", false);
        var x = component.get("v.SelectedValues");
        var item = component.get("v.item");
        console.log(x.includes(item))
        
        
        if(x.filter(x=> x.product2Id == item.product2Id).length >0 ){helper.totalCalculator(component); return}
        if(item.Quantity> 0){ 
            x.push(item);
        }
        component.set("v.SelectedValues",x);
        helper.totalCalculator(component);
        component.set("v.item",item);
    },
    decrement:function (component, event, helper) {
       // var buttonName = event.getSource().get('v.name');
        //var row = buttonName[1];
        //var column = buttonName[0];
        
        var quantity = component.find("inputId");
        if(!quantity.get('v.value')){
            quantity.set('v.value',0)
        }
        
        var x = component.get("v.SelectedValues");
        var item = component.get("v.item");
        
        var val = (quantity.get('v.value')) == '' ? 0 :(quantity.get('v.value'))
        var intVal= parseInt(val)
        var index = x.findIndex(v => v.product2Id === item.product2Id);
        if(intVal ==0 )
        {	
            if(index >-1){
                x.splice(index, 1);
                
                component.set("v.SelectedValues",x);
            }
            return
        }
        quantity.set('v.value',intVal - 1)
        
        if(intVal-1 ==0)
        {
            x.splice(x.findIndex(v => v.product2Id === item.product2Id), 1);
            
            component.set("v.SelectedValues",x);
            
        }
        helper.totalCalculator(component);
        component.set("v.item",item);
    }
})