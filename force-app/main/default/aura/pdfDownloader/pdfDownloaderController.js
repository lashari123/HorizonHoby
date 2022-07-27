({
    scriptsLoaded : function(component, event, helper) {
        var isAll = component.get('v.all')
       
        jQuery("document").ready(function(){
            var idtoPrint = "printTab"
            var isAll = $('#isAll').text();
            if(isAll != 'true'){
                idtoPrint = "printTabCurrent"
            }
            console.log('jQuery Loaded');
            
            var doc = new jspdf.jsPDF('l', 'pt', 'a4')   
          /*  var col = ["Sr. No.","Details"];
            var col1 = ["Details", "Values"];
            var rows = [];
            var rows1 = [];
            
            /* The following array of object as response from the API req
            
            
            
            var itemNew = [
                
                { index:'1',id: 'Case Number', name : '101111111' },
                { index:'2',id: 'Patient Name', name : 'UAT DR' },
                { index:'3',id: 'Hospital Name', name: 'Dr Abcd' }
                
            ]
            
            
            itemNew.forEach(element => {      
                var temp = [element.index,element.id];
                var temp1 = [element.id,element.name];
                rows.push(temp);
                rows1.push(temp1);
                
            });        
            
            doc.autoTable(col, rows, { startY: 10 });
            
            doc.autoTable(col1, rows1, { startY: 60 });
            doc.save('Test.pdf');*/
            var x = doc.internal.pageSize.width / 2 - (doc.getStringUnitWidth('Search Result') * doc.internal.getFontSize() / 2);
           // var offset = (doc.internal.pageSize.width / 2) - (doc.getStringUnitWidth(text) * doc.internal.getFontSize() / 2);
			doc.text('Search Result', x, 20);
            doc.setFontSize(11);
            doc.autoTable({
                html: '#'+idtoPrint,
                theme: 'plain',
                margin: {horizontal:5,top: 20, bottom: 40},
                startY: 0.1*doc.internal.pageSize.height,
                styles: {overflow: 'linebreak',fontSize:9,cellPadding:2,padding:2},
                columnStyles: {
                    0: {columnWidth: 'auto'}, 
                    1:{columnWidth: 'auto'}, 
                    2: {columnWidth: 'auto'}, 
                    3: {columnWidth: 'auto'},
                    5: {columnWidth: 'auto'}, 
                    6:{columnWidth:'auto'}, 
                    7: {columnWidth: 'auto'}, 
                    8: {columnWidth: 'auto'},
                    9: {columnWidth: 'auto'}, 
                    10:{columnWidth:'auto'}, 
                    11: {columnWidth: 'auto'}, 
                    12: {columnWidth: 'auto'},
                },
                headerStyles: {
                    lineWidth: 0,
                    lineColor: [0,0, 0]
                }
                // tableWidth: 180,
                // head: [['ID', 'Name', 'Email', 'Country', 'IP-address']],
                // body: [
                //   ['1', 'Donna', 'dmoore0@furl.net', 'China', '211.56.242.221'],
                //   ['2', 'Janice', 'jhenry1@theatlantic.com', 'Ukraine', '38.36.7.199'],
                //   [
                //     '3',
                //     'Ruth',
                //     'rwells2@constantcontact.com',
                //     'Trinidad and Tobago',
                //     '19.162.133.184',
                //   ],
                //   ['4', 'Jason', 'jray3@psu.edu', 'Brazil', '10.68.11.42'],
                //   ['5', 'Jane', 'jstephens4@go.com', 'United States', '47.32.129.71'],
                //   ['6', 'Adam', 'anichols5@com.com', 'Canada', '18.186.38.37'],
                // ],
                /*drawHeaderRow: (head, data) => {
                    data.doc.line(data.cursor.x, data.cursor.y + head.height, data.cursor.x + data.table.width, data.cursor.y + head.height);
                 }*/
            })
            var d = new Date();

            var month = d.getMonth()+1;
            var day = d.getDate();
            var hour = d.getHours();
            var minute = d.getMinutes();
			var seconds = d.getMilliseconds();
            
            /*var output = d.getFullYear() + '/' +
                (month<10 ? '0' : '') + month + '/' +
                (day<10 ? '0' : '') + day;*/
            var output = (month<10 ? '0' : '') + month + '/' +
                (day<10 ? '0' : '') + day + '/' + d.getFullYear();
            
             doc.setFontSize(8);
                    var output2 = 'Created ' + output + ' ' + hour + ':' + minute + ':' + seconds; 
             doc.text(output2, 5, doc.internal.pageSize.height-17 );
             var output1 = 'Please do not share any data or content from this partner site outside of your organization.'
                    doc.text(output1, doc.internal.pageSize.width / 2 - (doc.getStringUnitWidth(output1) * doc.internal.getFontSize() / 2), doc.internal.pageSize.height-17 );
            output = 'Product pricing is valid and subject to change at the discretion of Horizon Hobby.';
            doc.text(output, doc.internal.pageSize.width / 2 - (doc.getStringUnitWidth(output) * doc.internal.getFontSize() / 2), doc.internal.pageSize.height-5);
                    const pageCount = doc.internal.getNumberOfPages();
                for(var i = 1; i <= pageCount; i++) {
                    var pageNo = 'Page ' + String(i) + ' of ' + pageCount;
                    doc.text(pageNo, doc.internal.pageSize.width-5 - (doc.getStringUnitWidth(pageNo) * doc.internal.getFontSize()), doc.internal.pageSize.height-17);
                }
           doc.output('save', 'PDF.pdf');
           // function addFooters() {
                
           // }
            //addFooters();
            //doc.save();
            
            
            
            return
            
            
            
            var doc = new jspdf.jsPDF('p', 'pt', 'letter');
            // const doc = new jsPDF();
            
            doc.text("Hello world!", 10, 10);
            doc.save("a4.pdf");
            // source can be HTML-formatted string, or a reference
            // to an actual DOM element from which the text will be scraped.
            var source = $('#customers')[0];
            console.log(source)
            var w = document.getElementById("customers").offsetWidth;
            var h = document.getElementById("customers").offsetHeight;
            document.body.appendChild(source);
            html2canvas(source, {
                dpi: 300, // Set to 300 DPI
                scale: 3, // Adjusts your resolution
                onrendered: function(canvas) {
                    var img = canvas.toDataURL("image/jpeg", 1);
                    var doc = new jsPDF('L', 'px', [w, h]);
                    doc.addImage(img, 'JPEG', 0, 0, w, h);
                    doc.save('sample-file.pdf');
                }
            });
            return
            // we support special element handlers. Register them with jQuery-style 
            // ID selector for either ID or node name. ("#iAmID", "div", "span" etc.)
            // There is no support for any other type of selectors 
            // (class, of compound) at this time.
            var specialElementHandlers = {
                // element with id of "bypass" - jQuery style selector
                '#bypassme': function (element, renderer) {
                    // true = "handled elsewhere, bypass text extraction"
                    return true
                }
            };
            var margins = {
                top: 80,
                bottom: 60,
                left: 10,
                width: 700
            };
            // all coords and widths are in jsPDF instance's declared units
            // 'inches' in this case
            
            pdf.html(document.body, {
                callback: function (pdf) {
                    var iframe = document.createElement('iframe');
                    iframe.setAttribute('style', 'position:absolute;right:0; top:0; bottom:0; height:100%; width:500px');
                    document.body.appendChild(iframe);
                   // iframe.src = pdf.output('datauristring');
                   iframe.src = pdf.output('save', 'PDF.pdf');
                }
            });
            pdf.fromHTML(
                source, // HTML string or DOM elem ref.
                margins.left, // x coord
                margins.top, { // y coord
                    'width': margins.width, // max width of content on PDF
                    'elementHandlers': specialElementHandlers
                },
                
                function (dispose) {
                    // dispose: object with X, Y of the last line add to the PDF 
                    //          this allow the insertion of new lines after html
                    pdf.save('Test.pdf');
                }, margins);
        });
      
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Downloading!",
                "mode": "pester",
                "type":"success",
                "duration": 2000,
                "message": "PDF is downloading..."
            });
            toastEvent.fire();

        component.set('v.show',false)
    }
})