import { LightningElement, track } from 'lwc';

import getGermanTranslation from '@salesforce/apex/TranslationHelper.getAllGermanTranslation';
import getFrenchTranslation from '@salesforce/apex/TranslationHelper.getAllFrenchTranslation';
import getLabelsBySobjectName from '@salesforce/apex/TranslationHelper.getLabelsBySobjectName';
import getUserLanguage from '@salesforce/apex/TranslationHelper.getUserLanguage';

import getBackedOrder from '@salesforce/apex/HomePageCollapsibleController.getBackedOrder';
import getInvoiceHistory from '@salesforce/apex/HomePageCollapsibleController.getInvoiceHistory';
import getOrder from '@salesforce/apex/HomePageCollapsibleController.getOrder';



export default class LightningExampleAccordionConditional extends LightningElement {

  DraftOrders = 'Draft Orders'
  SubmittedOrders = 'Submitted Orders'
  Backorders = 'Backorders'
  OrderHistory = 'Order History'
  InvoiceHistory = 'Invoice History'
  @track Submitted = 'Submitted'
  // toTranslate = [this.DraftOrders, this.SubmittedOrders, this.Backorders]
  @track draftOrderdata = []
  @track backedOrderdata = []
  @track submittedOrderdata = []
  @track orderHistoryData = []
  @track invoiceHistoryData = []
    ;
  connectedCallback() {
    //var toTranslate = [this.DraftOrders, this.SubmittedOrders, this.Backorders]
    getUserLanguage().then((lc) => {
      debugger
      var lCode = lc
      if (lCode == 'de') {
        getGermanTranslation({ groupBy: 'Home' }).then((result) => {
          this.DraftOrders = result[this.DraftOrders]
          this.SubmittedOrders = result[this.SubmittedOrders]
          this.Backorders = result[this.Backorders]
          this.OrderHistory = result[this.OrderHistory]
          this.InvoiceHistory = result[this.InvoiceHistory]
          this.Submitted = result[this.Submitted]

          this.formatData(this.submittedOrderdata)
          // toTranslate.forEach(function(item, index, arr) {
          //     arr[index] = result[item];
          // });



        }).catch((e) => {
          var ex = e;
          console.log(ex)
        })
      }
      else if (lCode == 'fr') {
        getFrenchTranslation({ groupBy: 'Home' }).then((result) => {
          this.DraftOrders = result[this.DraftOrders]
          this.SubmittedOrders = result[this.SubmittedOrders]
          this.Backorders = result[this.Backorders]
          this.OrderHistory = result[this.OrderHistory]
          this.InvoiceHistory = result[this.InvoiceHistory]
          this.Submitted = result[this.Submitted]

          this.formatData(this.submittedOrderdata)

          // toTranslate.forEach(function(item, index, arr) {
          //     arr[index] = result[item];
          // });



        }).catch((e) => {
          var ex = e;
          console.log(ex)
        })
      }
      if (lCode != 'en_US') {
        getLabelsBySobjectName({ sObjectName: 'Order' }).then((result) => {

          this.draftOrderColumns = [
            { label: result['ordernumber'], fieldName: 'OrderNumber', type: 'text', typeAttributes: { required: true } },
            {
              label: result['ponumber'], fieldName: 'PoNumber', type: 'text',

            },
            { label: result['effectivedate'], fieldName: 'EffectiveDate', type: 'Date' },
            { label: result['status'], fieldName: 'Status', type: 'text' },
            {
              type: 'button',
              typeAttributes: {
                // label: {fieldName: 'nameMdmId'},
                label: 'View',
                variant: 'base',
              }
            },
          ]

          this.submittedOrderColumns = [
            { label: result['ordernumber'], fieldName: 'OrderNumber', type: 'text', typeAttributes: { required: true } },
            {
              label: result['ponumber'], fieldName: 'PoNumber', type: 'text',

            },
            { label: result['ordereddate'], fieldName: 'OrderedDate', type: 'Date' },
            { label: result['status'], fieldName: 'Status__c', type: 'text' },
            {
              type: 'button',
              typeAttributes: {
                // label: {fieldName: 'nameMdmId'},
                label: 'View',
                variant: 'base',
              }
            },
          ]
          this.orderHistoryColumns = [
            { label: result['ordernumber'], fieldName: 'OrderNumber', type: 'text', typeAttributes: { required: true } },
            {
              label: result['ponumber'], fieldName: 'PoNumber', type: 'text',

            },
            { label: result['ordereddate'], fieldName: 'OrderedDate', type: 'Date' },
            { label: result['status'], fieldName: 'status', type: 'text' },
            {
              type: 'button',
              typeAttributes: {
                // label: {fieldName: 'nameMdmId'},
                label: 'View',
                variant: 'base',
              }
            },
          ]

          this.invoiceHistoryColumns = [
            { label: 'invoice #', fieldName: 'Name', type: 'text', typeAttributes: { required: true } },

            { label: ' invoice Date', fieldName: 'Invoice_Date__c', type: 'Date' },
            { label: result['status'], fieldName: 'Status__c', type: 'text' },
            {
              type: 'button',
              typeAttributes: {
                // label: {fieldName: 'nameMdmId'},
                label: 'View',
                variant: 'base',
              }
            },


          ]


          this.backedOrderColumns = [

            { label: 'item #', fieldName: 'Name', type: 'text', },
            { label: 'Open Qty', fieldName: 'Quantity', type: 'number', },
            { label: result['effectivedate'], fieldName: 'EffectiveDate', type: 'Date' },
            { label: result['ordernumber'], fieldName: 'OrderNumber', type: 'text' },
            {
              label: result['ponumber'], fieldName: 'PoNumber', type: 'text',
            },
            {
              type: 'button',
              typeAttributes: {
                // label: {fieldName: 'nameMdmId'},
                label: 'View',
                variant: 'base',
              }
            },

          ]


        }).catch((e) => {
          var ex = e;
          console.log(ex)
        })
      }

    }).catch((e) => {
      var ex = e;
      console.log(ex)
    })

    getOrder({ 'Status': 'Draft' }).then((orders) => {
      debugger
      this.draftOrderdata = orders
      // alert(orders)


    }).catch((e) => {
      var ex = e;
      console.log(ex)
    })

    getOrder({ 'Status': 'Submitted' }).then((orders) => {
      debugger
      this.formatData(orders)

      //this.submittedOrderdata = orders

    }).catch((e) => {
      var ex = e;
      console.log(ex)
    })

    getOrder({ 'Status': 'Completed' }).then((orders) => {
      debugger 
      this.orderHistoryData = orders
      // alert(orders)


    }).catch((e) => {
      var ex = e;
      console.log(ex)
    })

    getBackedOrder().then((orders) => {
      debugger
      this.backedOrderdata = orders.map((item, index) => {
        let PoNumber = item.Order.PoNumber;
        let OrderNumber = item.Order.OrderNumber;
        let EffectiveDate = item.Order.EffectiveDate;
        let name = item.Product2.Name;
        debugger
        return { ...item, PoNumber: PoNumber, OrderNumber: OrderNumber, EffectiveDate: EffectiveDate ,Name: name}
      });
    }).catch((e) => {
      var ex = e;
      console.log(ex)
    })


    getInvoiceHistory().then((invoice) => {
      debugger
      this.invoiceHistoryData = invoice.map((item, index) => {

        debugger
        return { ...item }
      });
    }).catch((e) => {
      var ex = e;
      console.log(ex)
    })


  }

  formatData(pets) {
    this.submittedOrderdata = pets.map((item, index) => {
      let status__c = this.Submitted;
      debugger
      return { ...item, Status__c: status__c }
    });
  }

  @track draftOrderColumns = [
    { label: 'Order #', fieldName: 'OrderNumber', type: 'text', typeAttributes: { required: true } },
    {
      label: 'PO #', fieldName: 'PoNumber', type: 'text'

    },
    { label: 'Date Placed', fieldName: 'EffectiveDate', type: 'Date' },
    { label: 'Status', fieldName: 'Status', type: 'text' },
    {
      type: 'button',
      typeAttributes: {
        // label: {fieldName: 'nameMdmId'},
        label: 'View',
        variant: 'base',
      }
    },


  ]

  @track submittedOrderColumns = [
    { label: 'Order #', fieldName: 'OrderNumber', type: 'text', typeAttributes: { required: true } },
    {
      label: 'PO #', fieldName: 'PoNumber', type: 'text'

    },
    { label: 'Date', fieldName: 'OrderedDate', type: 'Date' },
    { label: 'Status', fieldName: 'Status__c', type: 'text' },
    {
      type: 'button',
      typeAttributes: {
        // label: {fieldName: 'nameMdmId'},
        label: 'View',
        variant: 'base',
      }
    },


  ]

  @track orderHistoryColumns = [
    { label: 'Order #', fieldName: 'OrderNumber', type: 'text', typeAttributes: { required: true } },
    {
      label: 'PO #', fieldName: 'PoNumber', type: 'text'

    },
    { label: 'Date', fieldName: 'EffectiveDate', type: 'Date' },
    { label: 'Status', fieldName: 'Status', type: 'text' },
    {
      type: 'button',
      typeAttributes: {
        // label: {fieldName: 'nameMdmId'},
        label: 'View',
        variant: 'base',
      }
    },


  ]

  @track invoiceHistoryColumns = [
    { label: 'invoice #', fieldName: 'Name', type: 'text', typeAttributes: { required: true } },

    { label: ' invoice Date', fieldName: 'Invoice_Date__c', type: 'Date' },
    { label: 'Status', fieldName: 'Status__c', type: 'text' },
    {
      type: 'button',
      typeAttributes: {
        // label: {fieldName: 'nameMdmId'},
        label: 'View',
        variant: 'base',
      }
    },


  ]


  @track backedOrderColumns = [

    { label: 'item #', fieldName: 'Name', type: 'text', },
    { label: 'Open Qty', fieldName: 'Quantity', type: 'number', },
    { label: 'Date placed', fieldName: 'EffectiveDate', type: 'Date' },
    { label: 'Order #', fieldName: 'OrderNumber', type: 'text' },
    {
      label: 'PO #', fieldName: 'PoNumber', type: 'text'

    },
    {
      type: 'button',
      typeAttributes: {
        // label: {fieldName: 'nameMdmId'},
        label: 'View',
        variant: 'base',
      }
    },


  ]

  handleRowActions(event) {


    event.preventDefault()
    var row = event.detail.row;
    alert(row.Id)
    window.console.log(JSON.stringify(row.Id));

  }
  section1 = 'slds-open'
  previousId = ''
  handleToggle(event) {
    debugger
    this.hideall()
    var e = event.currentTarget

    var id = e.getAttribute('data-id');
    if (this.previousId != id) {

      this.template.querySelector('[data-id="' + id + '"]').className = 'slds-accordion__section slds-is-open';
      this.previousId = id
    }
    else {
      this.template.querySelector('[data-id="' + id + '"]').className = 'slds-accordion__section';
      this.previousId = ''
    }



  }
  hideall() {
    this.template.querySelector('[data-id="section1"]').className = 'slds-accordion__section';
    this.template.querySelector('[data-id="section2"]').className = 'slds-accordion__section';
    this.template.querySelector('[data-id="section3"]').className = 'slds-accordion__section';
    this.template.querySelector('[data-id="section4"]').className = 'slds-accordion__section';
    this.template.querySelector('[data-id="section5"]').className = 'slds-accordion__section';
  }
}