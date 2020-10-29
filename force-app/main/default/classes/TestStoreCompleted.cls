@isTest
global class TestStoreCompleted implements HttpCalloutMock {
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        return response; 
    }
    @isTest static void testCallout(){
       Test.setMock(HttpCalloutMock.class, new TestStoreCompleted());
       Test.startTest();
       String jobId = System.schedule('SystemCalloutTest', CRON_EXP, new StoreCompleted());
       // Stopping the test will run the job synchronously
       Test.stopTest();
       List<Lending__c> lendings = new List<Lending__c>();
       lendings = [SELECT id from lending__c where isEnded__c = TRUE];
       System.assert(lendings.size()==0);
    }
}