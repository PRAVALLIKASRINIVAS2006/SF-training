trigger ApplicationIntegrationTrigger on Application__c (after update) {

    for (Application__c app : Trigger.new) {

        Application__c oldApp = Trigger.oldMap.get(app.Id);

        if (
            app.Status__c == 'Selected' &&
            oldApp.Status__c != 'Selected'
        ) {
            System.enqueueJob(
                new CandidateSyncQueueable(app.Id)
            );
        }
    }
}
