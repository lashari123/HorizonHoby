({
    scriptsLoaded : function(component, event, helper) {
        alert('test');
        jQuery("document").ready(function(){
            console.log(component.get("v.printAll"));
           // window.html2canvas = html2canvas
            var pdf = new jspdf.jsPDF('p', 'pt', 'a4');
		/*pdf.html(document.body, {
			callback: function (pdf) {
				var iframe = document.createElement('iframe');
				iframe.setAttribute('style', 'position:absolute;right:0; top:0; bottom:0; height:100%; width:500px');
				document.body.appendChild(iframe);
				iframe.src = pdf.output('datauristring');
			}
		});*/
            /*
            pdf.fromHTML($('#target').html(), 10, 10, {'width': 180});
            console.log('test2');
    pdf.autoPrint();
            console.log('test2');
    pdf.output("dataurlnewwindow");
            console.log('test2');
            */
            
            
            var html_container = document.getElementById("target"),
    		    html = html_container.innerHTML;
                    pdf.html(html, {
               callback: function (pdf) {
                   alert('final');
                 pdf.save();
               }
            });
            alert('final2');
           /* debugger;
            var canvas = document.getElementById("canvas"),
            	html_container = document.getElementById("target"),
    		    html = html_container.innerHTML;
            console.log(html);*/
           // rasterizeHTML.drawHTML(html, canvas);
            
/*           var myDocument = new jspdf.jsPDF();
            console.log('test2');
            var html_container = document.getElementById("target"),
    		    html = html_container.innerHTML;
            console.log(html);
           	 myDocument.html(document.body);*/
           //myDocument.text('Search Result', 10, 20);
            
          //  pdf.save("File.pdf");
            /*debugger;
            var myDocument = new jsPDF();
    	
        var specialElementHandlers = {
            "#exportc": function(element, rendrer){
                return true;
            }
        };
        
        myDocument.fromHTML($("#targets").html(), 15, 15, {
            "width":170,
            "elementHandlers": specialElementHandlers
        });
    
        myDocument.save("File.pdf");*/

});


    }
})