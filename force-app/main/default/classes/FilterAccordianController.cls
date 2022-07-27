public class FilterAccordianController {
	@AuraEnabled
    public static Object getCheckboxValues(){        
        return filterHelper.getFilterCheckboxValues();
    }
    
    @AuraEnabled
    public static Object getFilteredCheckboxValues(List<String> prodList){        
        return filterHelper.getFilteredCheckboxValues(prodList);
    }
    
    @AuraEnabled
    public static List<ProductCategory> getCategoriesCheckboxValues(Integer size){        
        return filterHelper.getCategories(size);
    }
    
    @AuraEnabled
    public static List<String> getFilteredCategoriesCheckboxValues(Integer size, List<String> prodList){        
        return filterHelper.getFilteredCategories(size, prodList);
    }
    
    @AuraEnabled
    public static List<Manufacturer__c> getManufacturerCheckboxValues(Integer size){        
        return filterHelper.getManufacturers(size);
    }
    
    @AuraEnabled
    public static List<String> getFilteredManufacturerCheckboxValues(Integer size, List<String> prodList){        
        return filterHelper.getFilteredManufacturers(size, prodList);
    }
        
    @AuraEnabled
    public static List<String> getRetailPriceCheckboxValues(Integer size){        
        return filterHelper.getRetailPrices(size);
    }
    
    @AuraEnabled
    public static List<String> getFilteredRetailPriceCheckboxValues(Integer size, List<String> prodList){        
        return filterHelper.getFilteredRetailPrices(size, prodList);
    }
    
    @AuraEnabled
    public static List<String> getCompletionLevelCheckboxValues(Integer size){        
        return filterHelper.getCompletionLevels(size);
    }
    
    @AuraEnabled
    public static List<String> getFilteredCompletionLevelCheckboxValues(Integer size, List<String> prodList){        
        return filterHelper.getFilteredCompletionLevels(size, prodList);
    }
    
    @AuraEnabled
    public static List<String> getScaleCheckboxValues(Integer size){        
        return filterHelper.getScales(size);
    }
    
    @AuraEnabled
    public static List<String> getFilteredScaleCheckboxValues(Integer size, List<String> prodList){        
        return filterHelper.getFilteredScales(size, prodList);
    }
    
    @AuraEnabled
    public static List<String> getPowerTypeCheckboxValues(Integer size){        
        return filterHelper.getPowerTypes(size);
    }
    
    @AuraEnabled
    public static List<String> getFilteredPowerTypeCheckboxValues(Integer size, List<String> prodList){        
        return filterHelper.getFilteredPowerTypes(size, prodList);
    }
    
    @AuraEnabled
    public static List<String> getVehicleTypeCheckboxValues(Integer size){        
        return filterHelper.getVehicleTypes(size);
    }
    
    @AuraEnabled
    public static List<String> getFilteredVehicleTypeCheckboxValues(Integer size, List<String> prodList){        
        return filterHelper.getFilteredVehicleTypes(size, prodList);
    }
}