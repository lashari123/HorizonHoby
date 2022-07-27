({
    changeFlagHelper : function() {
        $(document).ready(function () {
            
            function countryDropdown(seletor){
                var Selected = $(seletor);
                var Drop = $(seletor+'-drop');
                var DropItem = Drop.find('li');
                
                Selected.click(function(){
                    Selected.toggleClass('open');
                    Drop.toggle();
                });
                
                Drop.find('li').click(function(){
                    Selected.removeClass('open');
                    Drop.hide();
                    
                    var item = $(this);
                    Selected.html(item.html());
                });
                
                /*DropItem.each(function(){
					var code = $(this).attr('data-code');

					if(code != undefined){
						var countryCode = code.toLowerCase();
						$(this).find('i').addClass('flagstrap-'+countryCode);
					}
				});*/
                
                $(document).on("click", function (e) {
                    if ($(e.target).is(Selected) === false) {
                        Selected.removeClass('open');
                    	Drop.hide();
                    }
                });
            }
              
              countryDropdown('#country');
          });
    },
    
    toPascalCase : function () {
        return this.match(/[a-z]+/gi)
        .map(function (word) {
            return word.charAt(0).toUpperCase() + word.substr(1).toLowerCase()
        })
        .join('')
    }
})