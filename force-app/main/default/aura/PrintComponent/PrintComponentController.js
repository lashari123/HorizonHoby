({
    scriptsLoaded : function(component, event, helper) {
        component.set("v.isLoaded", true);
        setTimeout(function(){
            window.print();
        }, 2000);
    }
})