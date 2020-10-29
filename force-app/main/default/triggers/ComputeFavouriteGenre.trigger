trigger ComputeFavouriteGenre on Lending__c (after insert, after update, before delete) {
    List<User> users = new List<User>();
    List<Lending__c> lendings = Trigger.isDelete ? Trigger.old : Trigger.new;
    For(Lending__c lending: lendings){
        User user = [SELECT Id, Favourite_Book_Genre__c from user WHERE Id = :lending.User__c];
        sObject result = [SELECT Book__r.Genre__c from Lending__c where user__c = :user.Id group by Book__r.Genre__c order by count(id) desc limit 1];
        String favouriteGenre = (String) result.get('Genre__c');
        user.Favourite_Book_Genre__c = favouriteGenre;
        users.add(user);
    }
    update users;
}