trigger ManageLending on Lending__c (after insert, after update, after delete) {
    List<Book__c> booksToUpdate = new List<Book__c>();
    if(Trigger.isInsert){
        for(Lending__c lending: Trigger.New){
            if(!lending.isEnded__c){
            	//get a copy of the book!
            	Book__c book = [SELECT Name, Copies_Left__c FROM Book__c where id = :lending.Book__C];
                book.Copies_Left__c --;
                booksToUpdate.add(book);
            }            
        }
    }
    else if(Trigger.isUpdate){
        for(Lending__c lending: Trigger.New){
            if(lending.isEnded__c){
            	//return a copy!
            	Book__c book = [SELECT Name, Copies_Left__c FROM Book__c where id = :lending.Book__C];
                book.Copies_Left__c ++;
                booksToUpdate.add(book);
            }            
        }
    }
    else{
        for(Lending__c lending: Trigger.Old){
            if(!lending.isEnded__c){
            	//return a copy!
            	Book__c book = [SELECT Name, Copies_Left__c FROM Book__c where id = :lending.Book__C];
                book.Copies_Left__c ++;
                booksToUpdate.add(book);
            }            
        }
    }
    
    update booksToUpdate;
    
}