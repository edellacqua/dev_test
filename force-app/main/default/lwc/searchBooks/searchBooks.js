import { api, LightningElement, track, wire } from 'lwc';
import getLibraries from '@salesforce/apex/LibraryController.getLibraries';

let i = 0;
export default class SearchBooks extends LightningElement {
    @track value = '';
    @track error;
    @track items = [];
    @track filter = '';
    @track result = '';

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
    }

    filterChange(event) {
        this.filter = event.detail.value;
    }

    clickSearch(event) {
        this.result = this.filter;
    }
}