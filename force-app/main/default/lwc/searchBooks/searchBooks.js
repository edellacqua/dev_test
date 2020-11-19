import { api, LightningElement, track, wire } from 'lwc';
import getLibraries from '@salesforce/apex/LibraryController.getLibraries';
import { publish, MessageContext } from 'lightning/messageService';
import MYCH from '@salesforce/messageChannel/MyMessageChannel__c';

let i = 0;
export default class SearchBooks extends LightningElement {
    @track value = '';
    @track label = '';
    @track error;
    @track items = [];
    @track filter = '';

    @wire(MessageContext)
    messageContext;

    @wire(getLibraries, {})
    comboBoxItems({ error, data }) {
        if (data) {
            for(i=0; i<data.length; i++) {
                this.items = [...this.items ,{value: data[i].Id , label: data[i].Name}];                                   
            }
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.items = undefined;
        }
    }

    get options(){
        return this.items;      
    }
    
    handleChange(event) {
        this.value = event.detail.value;
        this.label = event.target.options.find(opt => opt.value === event.detail.value).label;
        const message = {recordData: {librarySearch: this.label, libraryId: this.value}};
        publish(this.messageContext, MYCH, message);
    }

    filterChange(event) {
        this.filter = event.detail.value;
    }

    clickSearch(event) {
        
        const message = {recordData: {textSearch: this.filter}};
        publish(this.messageContext, MYCH, message);
    }
}