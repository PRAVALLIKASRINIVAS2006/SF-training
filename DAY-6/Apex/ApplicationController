public with sharing class ApplicationController {

    @AuraEnabled(cacheable=true)
    public static List<Job__c> getEligibleJobs() {

        return ApplicationService.getEligibleJobs();
    }


    @AuraEnabled
    public static Id submitApplication(Id jobId) {

        if (jobId == null) {

            throw new AuraHandledException(
                'Please select a job before applying.'
            );
        }

        return ApplicationService.submitApplication(
            jobId
        );
    }
}
