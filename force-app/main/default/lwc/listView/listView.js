import { LightningElement, wire, api, track} from 'lwc';
import getUsersForLibrary from '@salesforce/apex/LibraryController.getUsersForLibrary';
import getBooksForLibrary from '@salesforce/apex/LibraryController.getBooksForLibrary';
import MYCH from '@salesforce/messageChannel/MyMessageChannel__c';

import {
    subscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';

const COLS = [
    { label: 'Name', fieldName: 'Name', editable: false },
    { label: 'Age', fieldName: 'Birth_Date__c', editable: false },
    { label: 'Gender', fieldName: 'Gender__c', editable: false}
];

const COLSSS = [
    {label: 'Name', fieldName: 'Name', editable: false},
    {label: 'Total Copies', fieldName: 'Total_number_of_copies__c', editable: false },
    {label: 'Available', fieldName: 'Copies_Left__c', editable: false}
];

export default class ListView extends LightningElement {
    @api filter='';
    @api idFilter='';
    columns = COLS;
    columnsss = COLSSS;
    @track error;
    @track users;
    @track books;
    @track draftvalues = [];
    @track draftbookvalues = [];

    // To pass scope, you must get a message context.
    @wire(MessageContext)
    messageContext;

    // Pass scope to the subscribe() method.
    connectedCallback() {
            subscribe(
                this.messageContext,
                MYCH,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
    }

    @wire(getBooksForLibrary, {lib: '$idFilter'})
    getBooks({error, data}){
        if(data){
            this.books = data;
            this.error = undefined;
            this.draftbookvalues = this.books;
        }
        else if(error){
            this.error = error;
            this.books = undefined;
        }
    }

    @wire(getUsersForLibrary, {lib : '$filter'})
    getUsers({ error, data }) {
        if (data) {
            this.users = data;
            this.error = undefined;
            this.draftvalues = this.users;
        } else if (error) {
            this.error = error;
            this.users = undefined;
        }
    }

    handleMessage(event){
        if(event.recordData.librarySearch){
            this.filter = event.recordData.librarySearch;
            this.idFilter = event.recordData.libraryId;
        }   
        else {
            let str = event.recordData.textSearch;
            if(str==="")
                this.draftvalues = this.users;
            else
                this.draftvalues = this.users.filter(row=> row.Name.toLowerCase().includes(str.toLowerCase()));
        }
    }
}