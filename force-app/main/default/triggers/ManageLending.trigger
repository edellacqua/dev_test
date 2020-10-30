trigger ManageLending on Lending__c (after insert, after update, after delete) {

    List<Book__c> booksToUpdate = new List<Book__c>();
    
    if(Trigger.isInsert){
        Map<Id, Lending__c> lendings = new Map<Id, Lending__c>(Trigger.new);
        //Select open lendings
        Map<Id, Lending__c> endedLendings = [SELECT id FROM Lending__c WHERE isEnded__c = FALSE AND id in :lendings.keySet];
        for(Lending__c l: endedLendings){
            Book__c c = l.Book_c;
            c.Copies_Left__c--;         //book a copy!
            booksToUpdate.add(book);
        }
    }
    
    else if(Trigger.isUpdate){
        Map<Id, Lending__c> lendings = new Map<Id, Lending__c>(Trigger.new);
        //Close a lending
        Map<Id, Lending__c> endedLendings = [SELECT id FROM Lending__c WHERE isEnded__c = TRUE AND id in :lendings.keySet];
        for(Lending__c l: endedLendings){
            Book__c c = l.Book_c;
            c.Copies_Left__c++;         //return a copy!
            booksToUpdate.add(book);
        }
    }

    else{           //delete
        Map<Id, Lending__c> lendings = new Map<Id, Lending__c>(Trigger.Old);
        Map<Id, Lending__c> endedLendings = [SELECT id FROM Lending__c WHERE isEnded__c = FALSE AND id in :lendings.keySet];
        for(Lending__c l: endedLendings){
            Book__c c = l.Book_c;
            c.Copies_Left__c++;         //return a copy!
            booksToUpdate.add(book);
        }
    }
    
    update booksToUpdate;
    
}