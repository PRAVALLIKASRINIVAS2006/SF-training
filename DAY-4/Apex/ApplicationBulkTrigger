trigger ApplicationBulkTrigger on Application__c (before insert, before update) {

    if (Trigger.isBefore) {
        ApplicationBulkTriggerHandler.validateApplications(Trigger.new);
    }

}
