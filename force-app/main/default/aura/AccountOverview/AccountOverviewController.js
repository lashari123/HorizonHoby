({
    doInit: function(component,event,helper){
        //get monthly sale and target:
        var action2 = component.get('c.getMonthlySales');
        action2.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp.MonthlySale!=null){
                    debugger;
                    component.set('v.monthlySale', resp.MonthlySale);
                    component.set('v.monthlyGoal', resp.MonthlyGoal);
                    component.set('v.earnedDiscount',resp.EarnedDiscount);
                    component.set('v.memberStatus',resp.CurrentMemberStatus);
                    var saleCompleted = resp.MonthlySale / resp.MonthlyGoal * 100;
                    component.set('v.monthlySalePercent', saleCompleted);
                    //component.set('v.monthlySale', resp.MonthlySale);
                }
                console.log(resp);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                }
            }
                else{
                    console.log(response.getReturnValue());
                }
        });
        
        //send action to be executed
        $A.enqueueAction(action2);
    },

    viewMembershipDocument: function(component,event,helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "https://horizonhobby--b2bdev.my.salesforce.com/sfc/p/6t0000004YsY/a/6t0000004Rd9/rp.DnHVFVZ8CFADCyvJL7uswKz.CVrbZDHo8cS9.KKQ"
        });
        urlEvent.fire();
        
    },
    
})