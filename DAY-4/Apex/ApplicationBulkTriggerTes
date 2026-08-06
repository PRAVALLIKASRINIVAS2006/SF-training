@IsTest
public class ApplicationBulkTriggerTest {

    @IsTest
    static void validateApplicationTest() {

        // Create Student
        Student__c stu = new Student__c(
            Name = 'Rahul',
            CGPA__c = 8
        );
        insert stu;

        // Create Job
        Job__c job = new Job__c(
            Name = 'Developer',
            Minimum_CGPA__c = 7,
            Last_Date__c = Date.today().addDays(30)
        );
        insert job;

        Test.startTest();

        // Create Application
        Application__c app = new Application__c(
            Name = 'Application Test',
            Student__c = stu.Id,
            Job__c = job.Id
        );

        insert app;

        Test.stopTest();

        // Verify Status
        Application__c result = [
            SELECT Status__c
            FROM Application__c
            WHERE Id = :app.Id
        ];

        System.assertEquals('Selected', result.Status__c);
    }
}
