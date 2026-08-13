trigger ApplicationTrigger on Application__c (before insert) {

    Set<Id> studentIds = new Set<Id>();
    Set<Id> jobIds = new Set<Id>();

    // Collect Student and Job IDs
    for(Application__c app : Trigger.new){
        if(app.Student__c != null)
            studentIds.add(app.Student__c);

        if(app.Job__c != null)
            jobIds.add(app.Job__c);

        // Default Status
        app.Status__c = 'Applied';
    }

    // Query Students
    Map<Id, Student__c> studentMap = new Map<Id, Student__c>(
        [SELECT Id, CGPA__c
         FROM Student__c
         WHERE Id IN :studentIds]
    );

    // Query Jobs
    Map<Id, Job__c> jobMap = new Map<Id, Job__c>(
        [SELECT Id,
                Minimum_CGPA__c,
                Last_Date__c
         FROM Job__c
         WHERE Id IN :jobIds]
    );

    // Existing Applications
    List<Application__c> existingApps = [
        SELECT Student__c, Job__c
        FROM Application__c
        WHERE Student__c IN :studentIds
        AND Job__c IN :jobIds
    ];

    Set<String> existingKeys = new Set<String>();

    for(Application__c app : existingApps){
        existingKeys.add(app.Student__c + '-' + app.Job__c);
    }

    // Validation
    for(Application__c app : Trigger.new){

        Student__c student = studentMap.get(app.Student__c);
        Job__c job = jobMap.get(app.Job__c);

        if(student != null && job != null){

            if(student.CGPA__c < job.Minimum_CGPA__c){
                app.addError('Student CGPA is below minimum requirement.');
            }

            if(Date.today() > job.Last_Date__c){
                app.addError('Application cannot be submitted after the last date.');
            }

            String key = app.Student__c + '-' + app.Job__c;

            if(existingKeys.contains(key)){
                app.addError('Student has already applied for this job.');
            }
        }
    }
}
