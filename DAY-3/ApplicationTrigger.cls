trigger ApplicationTrigger on Application__c (before insert, after update) {

    if (Trigger.isBefore && Trigger.isInsert) {
        ApplicationService.validateApplications(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        StatisticsService.updateStatistics(Trigger.new);
        NotificationService.sendNotifications(Trigger.new);
        AlumniService.updateAlumni(Trigger.new);
    }

}
