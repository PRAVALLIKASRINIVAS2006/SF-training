public with sharing class StudentProfileController {

    @AuraEnabled(cacheable=true)
    public static Student__c getStudent() {

        Id currentUserId = UserInfo.getUserId();

        List<Student__c> students = [
            SELECT Id,
                   Name,
                   CGPA__c,
                   User__c
            FROM Student__c
            WHERE User__c = :currentUserId
            LIMIT 1
        ];

        if (students.isEmpty()) {
            return null;
        }

        return students[0];
    }

    @AuraEnabled
    public static Student__c updateStudent(
        Id studentId,
        Decimal cgpa
    ) {

        Student__c student = [
            SELECT Id,
                   Name,
                   CGPA__c,
                   User__c
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];

        if (cgpa == null) {
            throw new AuraHandledException(
                'CGPA is required.'
            );
        }

        if (cgpa < 0 || cgpa > 10) {
            throw new AuraHandledException(
                'CGPA must be between 0 and 10.'
            );
        }

        student.CGPA__c = cgpa;

        update student;

        return student;
    }
}
