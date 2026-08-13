public class CandidateSyncQueueable implements Queueable, Database.AllowsCallouts {

    private Id applicationId;

    public CandidateSyncQueueable(Id applicationId) {
        this.applicationId = applicationId;
    }

    public void execute(QueueableContext context) {

        Application__c app = [
            SELECT Id,
                   Status__c,
                   Student__c,
                   Student__r.Name,
                   Student__r.Email__c,
                   Student__r.Branch__c,
                   Student__r.CGPA__c,
                   Job__c,
                   Job__r.Name,
                   Job__r.Company__c,
                   Job__r.Role__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        Map<String, Object> candidate = new Map<String, Object>();
        
        candidate.put('applicationId', app.Id);
        candidate.put('studentId', app.Student__c);
        candidate.put('name', app.Student__r.Name);
        candidate.put('email', app.Student__r.Email__c);
        candidate.put('branch', app.Student__r.Branch__c);
        candidate.put('cgpa', app.Student__r.CGPA__c);
        candidate.put('jobId', app.Job__c);
        candidate.put('company', app.Job__r.Company__c);
        candidate.put('role', app.Job__r.Role__c);
        candidate.put(
            'selectionDate',
            String.valueOf(Date.today())
        );

        String requestBody = JSON.serialize(candidate);

        HttpRequest request = new HttpRequest();

        request.setEndpoint(
            'callout:Recruitment_API/post'
        );

        request.setMethod('POST');

        request.setHeader(
            'Content-Type',
            'application/json'
        );

        request.setBody(requestBody);

        Http http = new Http();

        try {

            app.Last_Integration_Attempt__c = Date.today();

            HttpResponse response = http.send(request);

            Integer statusCode = response.getStatusCode();

            System.debug(
                'Status Code: ' + statusCode
            );

            System.debug(
                'Response Body: ' + response.getBody()
            );

            if (statusCode == 200 || statusCode == 201) {

                app.Integration_Status__c = 'Sent';

                Map<String, Object> responseData =
                    (Map<String, Object>) JSON.deserializeUntyped(
                        response.getBody()
                    );

                if (responseData.containsKey('externalCandidateId')) {

                    app.External_Candidate_Id__c =
                        String.valueOf(
                            responseData.get('externalCandidateId')
                        );
                }

                app.Integration_Error__c = null;

            } else if (statusCode == 400) {

                app.Integration_Status__c = 'Failed';

                app.Integration_Error__c =
                    'Bad Request: ' + response.getBody();

            } else if (statusCode == 401) {

                app.Integration_Status__c = 'Failed';

                app.Integration_Error__c =
                    'Authentication Failed: ' + response.getBody();

            } else if (statusCode == 403) {

                app.Integration_Status__c = 'Failed';

                app.Integration_Error__c =
                    'Forbidden: ' + response.getBody();

            } else if (statusCode == 500) {

                app.Integration_Status__c = 'Retry Required';

                app.Integration_Error__c =
                    'External Server Error: ' + response.getBody();

            } else {

                app.Integration_Status__c = 'Failed';

                app.Integration_Error__c =
                    'Unexpected Response (' +
                    statusCode +
                    '): ' +
                    response.getBody();
            }

        } catch (Exception e) {

            app.Integration_Status__c = 'Retry Required';

            app.Integration_Error__c =
                'Callout Exception: ' + e.getMessage();

        }

        update app;
    }
}
