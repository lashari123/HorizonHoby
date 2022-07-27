({
    doInit : function(component, event, helper) {
        var pid = helper.getUrlParameter(component,'pid');
        
        var action = component.get('c.getProductForPDP');
        action.setParams({ pid : pid});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null){
                    
                    component.set("v.variationColor",resp.variationColor[0]);
                    component.set("v.variationRedirect",resp.variationRedirect);
                    console.log("SUCCESS: getProductForPDP");
                    var pricebookEntry = resp.pricebookEntry;
                    pricebookEntry.forEach(function(item)
                                           {
                                               component.set("v.product",item.Product2);
                                               
                                               component.set("v.productName",item.Product2.Name);
                                               component.set("v.productCode",item.Product2.ProductCode);
                                               component.set("v.eta", new Date(item.Product2.ETA__c).toLocaleDateString("en-UK").replaceAll('/', '-'));
                                               if(item.Product2.IsActive){
                                                   component.set("v.isActive",'Active');
                                               } else{
                                                   component.set("v.isActive",'InActive');
                                               }
                                               if(item.Product2.Avail__c == 'Y'){
                                                   component.set("v.isStock",'In Stock');
                                               } else{
                                                   component.set("v.isStock",'Out of Stock');
                                               }
                                               
                                           //    component.set("v.totalPrice",item.UnitPrice);
                                           }); 
                    //document.getElementById('descriptionDiv').innerHTML += component.get("v.product").Description
                    
                    var manufacturer = resp.manufacturer;
                    manufacturer.forEach(function(item)
                                         {
                                             debugger
                                             component.set("v.manufacturerLogo",item.Logo_Id__c);
                                         });
                    component.set("v.unitPrice",resp.retailPrice);
                    component.set("v.dealerPrice",resp.dealerPrice);
                    
                    var actioni = component.get('c.getProductPriceRange');
                    actioni.setParams({ priceBookid : pricebookEntry[0].Id});
                    
                    actioni.setCallback(this, function(response){
                        var state = response.getState();
                        if(state === "SUCCESS") {
                            var resp = response.getReturnValue();
                            resp.forEach(function(item){
                                if(item.LowerBound > 1){
                                    item.LowerBound = item.LowerBound -1; 
                                }
                            });
                            component.set('v.priceRangeMap',resp)
                        }
                    });
                    
                    $A.enqueueAction(actioni);
                    
                    //component.set("v.isActive",iterationValues);
                } else{
                    console.log("SUCCESS: Wrong Product Entered");
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                }
            } else{
                console.log('Failed with state: ' + state);
            }
        });
        
        //send action to be executed
        $A.enqueueAction(action);
        
        //**************************************************************//
        //						Get Translation
        
        var locale = $A.get("$Locale.language");
        if(locale == 'de' || locale == 'fr'){
            var action = component.get("c.getTranslations");
            action.setParams({ langCode : locale});
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data =  response.getReturnValue();
                    //var message = component.get('v.message');
                    var addtoCart = component.get('v.addtoCart');
                    var originalPrice = component.get('v.originalPrice');
                    var YourPrice = component.get('v.YourPrice');
                    var Pricing = component.get('v.Pricing');
                    var Stock = component.get('v.Stock');
                    var itemDetails = component.get('v.itemDetails');
                    var review = component.get('v.review');
                    var Retail = component.get('v.Retail');
                    var Status = component.get('v.Status');
                    
                    addtoCart= data[addtoCart];
                    originalPrice= data[originalPrice];
                    YourPrice= data[YourPrice];
                    Pricing= data[Pricing];
                    Stock= data[Stock];
                    itemDetails= data[itemDetails];
                    review= data[review];
                    Retail= data[Retail];
                    Status= data[Status];
                    
                    component.set('v.addtoCart',addtoCart);
                    component.set('v.originalPrice',originalPrice);
                    component.set('v.YourPrice',YourPrice);
                    component.set('v.Pricing',Pricing);
                    component.set('v.Stock',Stock);
                    component.set('v.itemDetails',itemDetails);
                    component.set('v.review',review);
                    component.set('v.Retail',Retail);
                    component.set('v.Status',Status);
                    
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // log the error passed in to AuraHandledException
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    }
                }
            });
            $A.enqueueAction(action);
        }
        
        //Checking for Dealer Pricing
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.checkDealerPricing");
        action.setParams({ userId : userId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data =  response.getReturnValue();
                if(data != null){
                    component.set('v.isDealer',data);
                }
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    increment:function (component, event, helper) {
        
        
        var quantity = component.find("quantity");
        var intVal= parseInt(quantity.getElements()[0].value);
        if(intVal <0)
        {
            intVal=0
        }
        if(isNaN(intVal)){
            intVal=0
        }
        quantity.getElements()[0].value = intVal + 1;
        
        var unitPrice = component.get("v.unitPrice");
        var variationPrices = component.get('v.priceRangeMap')
        if(variationPrices){
            var quantity = (intVal + 1)
            variationPrices.forEach(function(item)
                                    {
                                        var lowerbound = 1
                                        if(item.LowerBound > 1){
                                            lowerbound =  item.LowerBound +1; 
                                        }
                                        if(lowerbound<= quantity && item.UpperBound >= quantity){
                                            
                                            
                                            unitPrice = item.TierValue
                                        }
                                    });
        }
        var totalPrice = unitPrice * (intVal + 1);
        component.set("v.totalPrice",totalPrice);
    },
    decrement:function (component, event, helper) {
        var quantity = component.find("quantity");
        var intVal= parseInt(quantity.getElements()[0].value);
        
        if(isNaN(intVal)){
            intVal=0
        }
        
        if(intVal-1 <0)
        {
            intVal=1
        }
        
        quantity.getElements()[0].value = intVal - 1;
        
        var unitPrice = component.get("v.unitPrice");
        var variationPrices = component.get('v.priceRangeMap')
        if(variationPrices){
            var quantity = (intVal - 1)
            variationPrices.forEach(function(item)
                                    {
                                        var lowerbound = 1
                                        if(item.LowerBound > 1){
                                            lowerbound =  item.LowerBound +1; 
                                        }
                                        if(lowerbound<= quantity && item.UpperBound >= quantity){
                                            
                                            
                                            unitPrice = item.TierValue
                                        }
                                    });
        }
        var totalPrice = unitPrice * (intVal - 1);
        component.set("v.totalPrice",totalPrice);
        
    },
    Add:function (component, event, helper) {
        var sku = component.get("v.productCode");
        var quantity = component.find("quantity");
        var intVal= parseInt(quantity.getElements()[0].value);
        
        var skuQuantityList = component.get("v.skuQuantityList");
        
        skuQuantityList[0] = sku + '_' + intVal;
        component.set("v.showAddToDraftOrder",true);
    },
    onChange : function(component,event,helper){ 
        debugger
        var quantity = component.find("quantity");
        var intVal= parseInt(quantity.getElements()[0].value);
        
        if(quantity.getElements()[0].value != '-' && isNaN(intVal)){
            intVal=''
        }
        
        if(intVal<0)
        {
            intVal*=-1
            quantity.getElements()[0].value = intVal;
        }
        
        
        
        var unitPrice = component.get("v.unitPrice");
            var variationPrices = component.get('v.priceRangeMap')
        if(variationPrices){
            var quantity = (intVal)
            variationPrices.forEach(function(item)
                                    {
                                        var lowerbound = 1
                                        if(item.LowerBound > 1){
                                            lowerbound =  item.LowerBound +1; 
                                        }
                                        if(lowerbound<= quantity && item.UpperBound >= quantity){
                                            
                                            
                                            unitPrice = item.TierValue
                                        }
                                    });
        }
        var totalPrice = unitPrice * (intVal);
        component.set("v.totalPrice",totalPrice);
        
    }, 
    
    productSlickSlider : function(component, event, helper) {
        
        var pid = helper.getUrlParameter(component,'pid');
        
        var action1 = component.get('c.getImages');
        action1.setParams({ 'pid' : pid});
        
        action1.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.imageUrls",resp)
                
                component.set("v.imageUrlsB",true)
               var action2 = component.get('c.getFeaturedImages');
                action2.setParams({ 'pid' : pid});
                
                action2.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS") {
                        var resp = response.getReturnValue();
                        component.set("v.featuredImages",resp)
                        
                        component.set("v.imageUrlsC",true)
                        $(document).ready(function () {
                            $('.product-slider').slick({
                                slidesToShow: 1,
                                slidesToScroll: 1,
                                arrows: false,
                                fade: true,
                                rows: 0,
                                asNavFor: '.slider-nav'
                            });
                            $('.slider-nav').slick({
                                slidesToShow: 5,
                                slidesToScroll: 1,
                                vertical: true,
                                asNavFor: '.product-slider',
                                dots: false,
                                rows: 0,
                                arrows: true,
                                centerMode: true,
                                focusOnSelect: true,
                                prevArrow:"<button type='button' class='slick-prev btn-default'><i class='fa fa-chevron-up' aria-hidden='true'></i></button>",
                                nextArrow:"<button type='button' class='slick-next btn-default'><i class='fa fa-chevron-down' aria-hidden='true'></i></button>"
                            });
                            $('.recommendation-slider').slick({
                                slidesToShow: 4,
                                slidesToScroll: 1,
                                arrows: true,
                                rows: 0,
                                prevArrow:"<button type='button' class='slick-prev'><i class='fa fa-chevron-left' aria-hidden='true'></i></button>",
                                nextArrow:"<button type='button' class='slick-next'><i class='fa fa-chevron-right' aria-hidden='true'></i></button>"
                            });
                            $('.tabslist a').on('click', function(event){
                                event.preventDefault();
                                $(this).closest('li').siblings('li').removeClass('active');
                                $(this).parent().addClass('active');
                                $($(this).attr('href')).addClass('tab-active').siblings().removeClass('tab-active');
                            });
                            $('.description-tabs .tab-opener').on('click', function(event){
                                event.preventDefault();
                                $(this).toggleClass('active');
                                $(this).closest('.tab-pane').siblings().find('.tab-opener').removeClass('active');
                                $(this).siblings('.content').slideToggle();
                                $(this).closest('.tab-pane').siblings().find('.content').slideUp();
                            });
                        });
                    }
                });
                
                //send action to be executed
                $A.enqueueAction(action2);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                }
            } else{
                console.log('Failed with state: ' + state);
            }
        });
        
        //send action to be executed
        $A.enqueueAction(action1);
        
        var action3 = component.get('c.getSliderVideos');
        action3.setParams({ 'pid' : pid});
                
        action3.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.sliderVideos",resp)
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                }
            } else{
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action3);
    },
    productTabs : function(component,event,helper){ 
        $(document).ready(function () {
            $('.tabslist a').on('click', function(event){
                event.preventDefault();
                $(this).closest('li').siblings('li').removeClass('active');
                $(this).parent().addClass('active');
                $($(this).attr('href')).addClass('tab-active').siblings().removeClass('tab-active');
            });
            $('.description-tabs .tab-opener').on('click', function(event){
                event.preventDefault();
                $(this).toggleClass('active');
                $(this).closest('.tab-pane').siblings().find('.tab-opener').removeClass('active');
                $(this).siblings('.content').slideToggle();
                $(this).closest('.tab-pane').siblings().find('.content').slideUp();
            });
        });
    }
    
})