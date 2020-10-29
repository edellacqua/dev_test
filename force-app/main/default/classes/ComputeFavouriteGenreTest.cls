@isTest 
public class ComputeFavouriteGenreTest {
    @isTest static void TestFavouriteGenreUpdate(){
        Library__c library = new Library__c(Name = 'TestLibrary');
        insert library;
        Book__c book = new Book__c(Code__c = 'TESTCODE33', Name = 'TestBook', Genre__c = 'Tragedy', Library__c = library.id, Total_number_of_copies__c = 50, Copies_Left__c = 50);
        insert book;
        User u = [SELECT id from User where username = 'mdantonio@deloitte.it.esedoardodellacqua'];
        Test.startTest();
        Lending__c lending = new Lending__c(Name = 'Test Lending', Book__c = book.Id, User__c = u.Id, Start_Date__c = Date.today());
        insert lending;
        Test.stopTest();
        String favouriteGenre = [SELECT Favourite_Book_Genre__c from user WHERE Username = 'mdantonio@deloitte.it.esedoardodellacqua'].Favourite_Book_Genre__c;
        System.assertEquals('Tragedy', favouriteGenre);
    }

}