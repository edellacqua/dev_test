public with sharing class LibraryController {
    @AuraEnabled(cacheable = true)
    public static List<Library__c> getLibraries(){
        return [SELECT Id, Name FROM Library__c];
    }
}
