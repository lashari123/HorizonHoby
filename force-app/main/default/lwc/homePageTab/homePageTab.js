import { LightningElement } from 'lwc';

import getGermanTranslation from '@salesforce/apex/TranslationHelper.getAllGermanTranslation';
import getUserLanguage from '@salesforce/apex/TranslationHelper.getUserLanguage';
export default class HomePageTab extends LightningElement {
    NewReleases = 'New Release'
    TopSellingItem = 'Top Selling Item'
    NewLyInStock = 'Newly In-Stock'
    connectedCallback() {
        getUserLanguage().then((lc) => {
            debugger
            var lCode = lc
            if (lCode == 'de') {
                getGermanTranslation({ groupBy: 'Home' }).then((result) => {
                    this.NewReleases = result[this.NewReleases]
                    this.TopSellingItem = result[this.TopSellingItem]
                    this.NewLyInStock = result[this.NewLyInStock]
                }).catch((e) => {
                    var ex = e;
                    console.log(ex)
                })
            }

        }).catch((e) => {
            var ex = e;
            console.log(ex)
        })

    }

}