({
    init : function(component, event, helper) {
        var opertors = ["=","!=","<","<=",">",">=","LIKE","IN","NOT IN"];
        component.set("v.operators",opertors)
        
        var parseStringList = component.get('v.parseStringList')
        
        if(parseStringList.length> 0){
            var index = component.get('v.index')
            if(index < parseStringList.length){
                var parseString = parseStringList[index].split(',')
               

                
                component.set('v.Condition',parseString[0])
                
                component.set('v.Object',parseString[1])
                
                var selectedObject = parseString[1]
                
                helper.setFieldValues(component,selectedObject)
                component.set('v.Field',parseString[2])
                component.set('v.Operator',parseString[3])
                component.set('v.Input',parseString[4])
                
                 
                component.set("v.showFields",true);
                if(index>0){
                    component.set("v.conditionalOperator",false);
                }
                parseString[1] = ''
              //  component.set('v.parseStringList',parseString)
                component.set('v.conditionList',parseString)
                helper.setText(component);
            }
        }
    },
    
    showFields : function(component, event, helper) {
        component.set("v.conditionalOperator",false);
        
        var conditionList = component.get('v.conditionList')
        conditionList[0] = event.getSource().get('v.value');
        component.set('v.conditionList',conditionList)
        
        helper.setText(component);
    },
    
    GetFields : function(component, event, helper) {
        var selectedObject = event.getSource().get("v.value");
        helper.setFieldValues(component,selectedObject)
        component.set("v.showFields",true);
    },
    
    setFieldName : function(component, event, helper) {
        
        var conditionList = component.get('v.conditionList')
        conditionList[2] = event.getSource().get('v.value');
        component.set('v.conditionList',conditionList)
        
        helper.setText(component);
    },
    
    setOperator:  function(component, event, helper) {
        
        var conditionList = component.get('v.conditionList')
        conditionList[3] = event.getSource().get('v.value');
        component.set('v.conditionList',conditionList)
        
        helper.setText(component);
    },
    
    setValue :  function(component, event, helper) {
        
        
        var conditionList = component.get('v.conditionList')
        conditionList[4] = event.getSource().get('v.value');
        component.set('v.conditionList',conditionList)
        
        helper.setText(component);
        
    }
})