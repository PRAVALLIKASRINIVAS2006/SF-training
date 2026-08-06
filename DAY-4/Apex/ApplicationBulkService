public class ApplicationBulkService {

    public static void validateStudentEligibility(List<Application__c> applications) {

        Set<Id> studentIds = new Set<Id>();
        Set<Id> jobIds = new Set<Id>();

        // Collect Student and Job IDs
        for (Application__c app : applications) {

            if (app.Student__c != null) {
                studentIds.add(app.Student__c);
            }

            if (app.Job__c != null) {
                jobIds.add(app.Job__c);
            }
        }

        // Return if there are no Student or Job records
        if (studentIds.isEmpty() || jobIds.isEmpty()) {
            return;
        }

        // Query Student records
        Map<Id, Student__c> studentMap = new Map<Id, Student__c>(
            [SELECT Id, CGPA__c
             FROM Student__c
             WHERE Id IN :studentIds]
        );

        // Query Job records
        Map<Id, Job__c> jobMap = new Map<Id, Job__c>(
            [SELECT Id, Minimum_CGPA__c
             FROM Job__c
             WHERE Id IN :jobIds]
        );

        // Validate each Application
        for (Application__c app : applications) {

            if (app.Student__c == null || app.Job__c == null) {
                continue;
            }

            Student__c stu = studentMap.get(app.Student__c);
            Job__c job = jobMap.get(app.Job__c);

            if (stu != null && job != null) {

                if (stu.CGPA__c >= job.Minimum_CGPA__c) {
                    app.Status__c = 'Selected';
                } else {
                    app.Status__c = 'Rejected';
                }

            }
        }
    }
}
