import { LightningElement, api, track } from 'lwc';

const CARD_VISIBLE_CLASSES = 'fade slds-show'
const CARD_HIDDEN_CLASSES = 'fade slds-hide'

const DOT_VISIBLE_CLASSES = 'dot active'
const DOT_HIDDEN_CLASSES = 'dot'

const DEFAULT_SLIDER_TIMER = 3000 // 3 second
const DEFAULT_SLIDER_WIDTH = 700


export default class CustomSliderChild extends LightningElement {
    @track slides = []
    slideIndex = 1
    timer
    @api isCompleted = false

    @api slideTimer = DEFAULT_SLIDER_TIMER
    @api enableAutoScroll = false
    @api customWidth = DEFAULT_SLIDER_WIDTH
    @api showFull = false

    get maxWidth() {
        console.log('width:'+(this.customWidth)+'px')
        return this.showFull ? 'width:100%' : 'width:'+(this.customWidth)+'px'
    }

    @api
    get slidesData() {
        return this.slides
    }


    set slidesData(data) {
        this.slides = data.map((item, index) => {
            return index === 0 ? {
                ...item,
                slideIndex: index + 1,
                cardClasses: CARD_VISIBLE_CLASSES,
                dotClases: DOT_VISIBLE_CLASSES
            } : {
                    ...item,
                    slideIndex: index + 1,
                    cardClasses: CARD_HIDDEN_CLASSES,
                    dotClases: DOT_HIDDEN_CLASSES
                }
        })
    }

    connectedCallback() {
        this.enableAutoScroll = true
    }
    @api getImagesData(data) {
        debugger
        this.slidesData = data;
        console.log(data)
        debugger
        if (this.enableAutoScroll) {
            this.timer = window.setInterval(() => {
                this.slideSelectionHandler(this.slideIndex + 1)
            }, Number(this.slideTimer))
        }
    }

    disconnectedCallback() {
        if (this.enableAutoScroll) {
            window.clearInterval(this.timer)
        }
    }
    currentSlide(event) {
        let slideIndex = Number(event.target.dataset.id)
        this.slideSelectionHandler(slideIndex)
    }
    backSlide() {
        let slideIndex = this.slideIndex - 1
        this.slideSelectionHandler(slideIndex)
    }
    forwardSlide() {
        let slideIndex = this.slideIndex + 1
        this.slideSelectionHandler(slideIndex)
    }

    slideSelectionHandler(id) {
        if (id > this.slides.length) {
            this.slideIndex = 1
        } else if (id < 1) {
            this.slideIndex = this.slides.length
        } else {
            this.slideIndex = id
        }
        this.slides = this.slides.map(item => {
            return this.slideIndex === item.slideIndex ? {
                ...item,
                cardClasses: CARD_VISIBLE_CLASSES,
                dotClases: DOT_VISIBLE_CLASSES
            } : {
                    ...item,
                    cardClasses: CARD_HIDDEN_CLASSES,
                    dotClases: DOT_HIDDEN_CLASSES
                }
        })
    }

}