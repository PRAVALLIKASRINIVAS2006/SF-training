public class ApplicationService {

    public static void validateApplications(List<Application__c> applications) {

        for(Application__c app : applications){

            if(app.Student__c == null){
                app.addError('Student is required.');
            }

            if(app.Job__c == null){
                app.addError('Job is required.');
            }

            if(app.Application_Date__c == null){
                app.addError('Application Date is required.');
            }

        }

    }
