@IsTest
global class CandidateSyncMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {

        System.debug(
            'Request Body: ' + request.getBody()
        );

        HttpResponse response = new HttpResponse();

        response.setStatusCode(201);

        response.setHeader(
            'Content-Type',
            'application/json'
        );

        response.setBody(
            '{"success":true,"externalCandidateId":"EXT10001"}'
        );

        return response;
    }
}
