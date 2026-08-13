public with sharing class EligibleJobsController {

    @AuraEnabled(cacheable=true)
    public static List<Job__c> getEligibleJobs(Decimal cgpa) {

        if (cgpa == null) {
            return new List<Job__c>();
        }

        return [
            SELECT Id,
                   Name,
                   Minimum_CGPA__c,
                   Last_Date__c
            FROM Job__c
            WHERE Minimum_CGPA__c <= :cgpa
            ORDER BY Minimum_CGPA__c DESC
        ];
    }
}
