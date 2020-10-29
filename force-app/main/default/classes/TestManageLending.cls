@isTest
public class TestManageLending {
    private integer copiesLeft = 50;
    
    @isTest static void insertLendingNotEnded(){
        Test.startTest();
        insertTestLibraryBookAndLending(false);
        Test.stopTest();
        Book__c book = [select Copies_Left__c from Book__c where Code__c = 'TESTCODE33'];
        System.assertEquals(49, book.Copies_Left__c);  
    }
    
    @isTest static void insertLendingEnded(){
        Test.startTest();
        insertTestLibraryBookAndLending(true);
        Test.stopTest();
        Book__c book = [select Copies_Left__c from Book__c where Code__c = 'TESTCODE33'];
        System.assertEquals(50, book.Copies_Left__c);  
    }
    
    @isTest static void updateLendingNotEnded(){
        Test.startTest();
        Lending__c l = insertTestLibraryBookAndLending(false);
        Date d = Date.newInstance(2030, 2, 17);
        l.End_Date__c = d;
        update l;
        Test.stopTest();
        Book__c book = [select Copies_Left__c from Book__c where Code__c = 'TESTCODE33'];
        System.assertEquals(49, book.Copies_Left__c); 
    }
    
    @isTest static void updateLendingEnded(){
        Test.startTest();
        Lending__c l = insertTestLibraryBookAndLending(false);
        Date d = Date.newInstance(2020, 3, 17);
        l.End_Date__c = d;
        System.debug(d);
        update l;
        Test.stopTest();
        Book__c book = [select Copies_Left__c from Book__c where Code__c = 'TESTCODE33'];
        System.assertEquals(50, book.Copies_Left__c); 
    }
    
    @isTest static void deleteLendingEnded(){
        Test.startTest();
        Lending__c l = insertTestLibraryBookAndLending(true);
        delete l;
        Test.stopTest();
        Book__c book = [select Copies_Left__c from Book__c where Code__c = 'TESTCODE33'];
        System.assertEquals(50, book.Copies_Left__c); 
    }
    
    @isTest static void deleteLendingNotEnded(){
        Test.startTest();
        Lending__c l = insertTestLibraryBookAndLending(false);
        delete l;
        Test.stopTest();
        Book__c book = [select Copies_Left__c from Book__c where Code__c = 'TESTCODE33'];
        System.assertEquals(50, book.Copies_Left__c); 
    }
    
    private static Lending__c insertTestLibraryBookAndLending(boolean isEnded){
        
        User u = [SELECT id from user where username = 'mdantonio@deloitte.it.esedoardodellacqua'];
        
        Library__c library = new Library__c(Name = 'TestLibrary');
        insert library;
        
        Book__c book = new Book__c(Code__c = 'TESTCODE33', Name = 'TestBook', Genre__c = 'Tragedy', Library__c = library.id, Total_number_of_copies__c = 50, Copies_Left__c = 50);
    	insert book;
        
        Date d;
        
        if(isEnded){
           d = Date.newInstance(2020, 2, 17);
        }
        else{
           d = Date.newInstance(2025, 2, 17);
        } 
        
        Lending__c lending = new Lending__c(Name = 'Test Lending', Book__c = book.Id, User__c = u.Id, Start_Date__c = Date.newInstance(2015, 2, 17), End_Date__c=d);
        insert lending;
        
        return lending;
    }

}