({
    getUrlParameter : function(cmp,sParam) {
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
    
    getTranslation : function(cmp, event, helper){
        /*
        debugger
        var locale = $A.get("$Locale.language");
        var action = cmp.get("c.getTranslations");
        action.setParams({ langCode : locale});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 	{
                
                var data =  response.getReturnValue();
                
                var column = cmp.get('v.columns');
                column.forEach(x => x.label = data[x.label] != null ? data[x.label] : x.label );
                cmp.set('v.columns',column);
               
                cmp.set('v.Translations',data)
                cmp.set('v.OrderSummary',data[cmp.get('v.OrderSummary')])
                cmp.set('v.OriginalPrice',data[cmp.get('v.OriginalPrice')])
                cmp.set('v.Discount',data[cmp.get('v.Discount')])
                cmp.set('v.Shipping',data[cmp.get('v.Shipping')])
                cmp.set('v.SalesTax',data[cmp.get('v.SalesTax')])
                cmp.set('v.OrderDetails',data[cmp.get('v.OrderDetails')])
                cmp.set('v.YourPrice',data[cmp.get('v.YourPrice')])
                cmp.set('v.awayfromFreeShipping',data[cmp.get('v.awayfromFreeShipping')])
                cmp.set('v.Checkout',data[cmp.get('v.Checkout')])
                cmp.set('v.ContactInformation',data[cmp.get('v.ContactInformation')])
                cmp.set('v.Name',data[cmp.get('v.Name')])
                cmp.set('v.OrderInformation',data[cmp.get('v.OrderInformation')])
                cmp.set('v.Edit',data[cmp.get('v.Edit')])
            }
        });
        $A.enqueueAction(action);*/
    }
 
})