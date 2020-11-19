public with sharing class LibraryController {
    @AuraEnabled(cacheable = true)
    public static List<Library__c> getLibraries(){
        return [SELECT Id, Name FROM Library__c];
    }

    @AuraEnabled(cacheable = true)
    public static List<User> getUsersForLibrary(String lib){
        if(!lib.equals(''))
            return [SELECT Id, Name, Birth_Date__c, Gender__c FROM User WHERE Registration_Library__c = :lib ];
        else 
            return new List<User>();
    }

    @AuraEnabled(cacheable = true)
    public static List<Book__c> getBooksForLibrary(Id lib){
        if(lib!=null)
            return [SELECT Id, Name, Total_number_of_copies__c, Copies_Left__c FROM Book__c WHERE Library__c = :lib];
        else 
            return new List<Book__c>();
    }

}
