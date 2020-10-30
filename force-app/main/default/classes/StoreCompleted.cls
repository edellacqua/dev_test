global class StoreCompleted implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        
        postToExternalSystem(); //Callout to external system
        
        //delete old completed lendings
        List<Lending__c> lendingsCompleted = [SELECT Id from lending__c where isEnded__c = true];
        delete lendingsCompleted;		
    }
    
    @future(callout = true) 
    global static void postToExternalSystem(){

        Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('http://www.mocky.io/v2/5bcef5d53300009000c246d3');
		request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode()==200){
            System.debug('request succesful!');
        }
    }
}