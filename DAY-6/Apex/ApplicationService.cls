public with sharing class ApplicationService {

    // Get jobs for the current student
    public static List<Job__c> getEligibleJobs() {

        Id currentUserId = UserInfo.getUserId();

        Student__c student = [
            SELECT
                Id,
                Name,
                CGPA__c
            FROM Student__c
            WHERE User__c = :currentUserId
            LIMIT 1
        ];

        List<Job__c> jobs = [
            SELECT
                Id,
                Name,
                Minimum_CGPA__c,
                Deadline__c
            FROM Job__c
            WHERE Deadline__c >= :Date.today()
            ORDER BY Deadline__c ASC
        ];

        List<Job__c> eligibleJobs =
            new List<Job__c>();

        for (Job__c job : jobs) {

            if (
                job.Minimum_CGPA__c == null ||
                student.CGPA__c >= job.Minimum_CGPA__c
            ) {
                eligibleJobs.add(job);
            }
        }

        return eligibleJobs;
    }


    // Submit application
    public static Id submitApplication(Id jobId) {

        if (jobId == null) {

            throw new AuraHandledException(
                'Please select a job before applying.'
            );
        }


        Id currentUserId = UserInfo.getUserId();


        // Get Student
        Student__c student = [
            SELECT
                Id,
                Name,
                CGPA__c
            FROM Student__c
            WHERE User__c = :currentUserId
            LIMIT 1
        ];


        // Get Job
        Job__c job = [
            SELECT
                Id,
                Name,
                Minimum_CGPA__c,
                Deadline__c
            FROM Job__c
            WHERE Id = :jobId
            LIMIT 1
        ];


        // Check deadline
        if (
            job.Deadline__c != null &&
            job.Deadline__c < Date.today()
        ) {

            throw new AuraHandledException(
                'Applications for this job are closed.'
            );
        }


        // Check CGPA
        if (
            job.Minimum_CGPA__c != null &&
            student.CGPA__c != null &&
            student.CGPA__c < job.Minimum_CGPA__c
        ) {

            throw new AuraHandledException(
                'You are not eligible for this job.'
            );
        }


        // Check duplicate application
        List<Application__c> existingApplications = [
            SELECT Id
            FROM Application__c
            WHERE Student__c = :student.Id
            AND Job__c = :job.Id
            LIMIT 1
        ];


        if (!existingApplications.isEmpty()) {

            throw new AuraHandledException(
                'You have already applied for this job.'
            );
        }


        // Create Application
        Application__c applicationRecord =
            new Application__c();

        applicationRecord.Student__c =
            student.Id;

        applicationRecord.Job__c =
            job.Id;

        applicationRecord.Status__c =
            'Applied';


        insert applicationRecord;


        return applicationRecord.Id;
    }
}
