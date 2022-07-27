import getApexData from '@salesforce/apex/customSliderController.getImagesUrls';
import image1 from '@salesforce/resourceUrl/homePageSlide1';
import image2 from '@salesforce/resourceUrl/homePageSlide2';
import image3 from '@salesforce/resourceUrl/homePageSlide';
import { LightningElement, api, track, wire } from 'lwc';
export default class CustomSlider extends LightningElement {


    img1 = image1;
    img2 = image2;
    img3 = image3;
    @track isCom;
    @track imageUrl = [
    ]

    connectedCallback() {
        debugger



        getApexData()
            .then(result => {

                var list = result;
                console.log(list)
                list.forEach(currentItem => {
                    currentItem.heading = 'Caption one';
                    currentItem.description = 'You can add description of first slide here'
                    var testimageUrl = {
                        image_Url__c: currentItem.image_Url__c,
                        heading: currentItem.heading,
                        description: currentItem.description
                    }
                    this.imageUrl.push(testimageUrl)
                });
                console.log(this.imageUrl)
                this.isCom = true
                this.template.querySelector('c-custom-slider-child').getImagesData(this.imageUrl);
            })
            .catch(error => {
                this.error = error;
            });
    }


}