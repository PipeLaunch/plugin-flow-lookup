/**
 * @description       : HTTP Request Service HttpCalloutMock
 *
 * https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http_testing_httpcalloutmock.htm
 *
 * @author            : samuel@pipelaunch.com
 * @group             : HttpRequest Class
 * @last modified on  : 2023-03-28
 * @last modified by  : samuel@pipelaunch.com
 **/
@isTest
public with sharing class HttpRequestServiceMockTest implements HttpCalloutMock {
    /**
     * @description Mock simple empty JSON response
     * @author samuel@pipelaunch.com | 2022-12-07
     * @param req
     * @return HttpResponse
     **/
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{}');
        res.setStatusCode(200);
        return res;
    }
}
