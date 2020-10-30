trigger ManageLending on Lending__c (after insert, after update, before delete) {
    
    if(Trigger.isInsert){
        Map<Id, Lending__c> lendings = new Map<Id, Lending__c>(Trigger.new);
        //Select open lendings
        List<Book__c> books = [SELECT Id, Copies_Left__c from Book__c where id in (SELECT Book__c FROM Lending__c where Id in: lendings.KeySet() AND isEnded__c = FALSE)];
        
        for(Book__c b: books){
            b.Copies_Left__c--;        //book a copy!
        }

        update books;
    }
    
    else if(Trigger.isUpdate){
        Map<Id, Lending__c> lendings = new Map<Id, Lending__c>(Trigger.new);
        //Close a lending
        List<Book__c> books = [SELECT Id, Copies_Left__c from Book__c where id in (SELECT Book__c FROM Lending__c where Id in: lendings.KeySet() AND isEnded__c = TRUE)];
        
        for(Book__c b: books){
            b.Copies_Left__c++;         //book a copy!
        }

        update books;
    }

    else{           //delete
        Map<Id, Lending__c> lendings = new Map<Id, Lending__c>(Trigger.Old);
        List<Book__c> books = [SELECT Id, Copies_Left__c from Book__c where id in (SELECT Book__c FROM Lending__c where Id in: lendings.KeySet() AND isEnded__c = FALSE)];
        
        for(Book__c b: books){
            b.Copies_Left__c++;         //book a copy!
        }

        update books;
    }
    
}