({
	getUrlParameter : function(component,sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sParameterName,
            i;
        
            sParameterName = sPageURL.split('=');
            
            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
    }
})