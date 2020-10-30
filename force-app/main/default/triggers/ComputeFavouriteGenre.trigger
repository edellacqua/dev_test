trigger ComputeFavouriteGenre on Lending__c (after insert, after update, before delete) {
    
    List<Lending__c> lendingsList = Trigger.isDelete ? Trigger.old : Trigger.new;
    Map<Id, Lending__C> lendings = new Map<Id, Lending__c>(lendingsList);
    List<User> users = new List<User>();

    for(User user: [SELECT Id from user where id in (SELECT User__c from lending__c where id in :lendings.KeySet())]){
        sObject result = [SELECT Book__r.Genre__c from Lending__c where user__c = :user.Id group by Book__r.Genre__c order by count(id) desc limit 1];
        String favouriteGenre = (String) result.get('Genre__c');
        user.Favourite_Book_Genre__c = favouriteGenre;
        users.add(user);
    }
    
    update users;
}