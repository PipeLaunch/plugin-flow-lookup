/**
 * @description       : HTTP Request Service Tests
 * @group             : HttpRequest Class
 **/
@isTest
public with sharing class HttpRequestServiceTest {
    @isTest
    static void getResponses() {
        // StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        // mock.setStaticResource('Mock_Pipelaunch');
        // mock.setStatusCode(200);
        // Test.setMock(HttpCalloutMock.class, mock);
        Test.setMock(HttpCalloutMock.class, new HttpRequestServiceMockTest());

        Map<String, Object> queryParameters = new Map<String, Object>();
        queryParameters.put('param1', 'value1');
        queryParameters.put('param2', '');
        queryParameters.put('', 'value3');

        Map<String, String> headers = new Map<String, String>();
        headers.put('header1', 'value1');

        Test.startTest();

        HttpResponse getResponse = HttpRequestService.sendGetRequest(
            'http://www.google.com',
            queryParameters
        );
        HttpResponse postResponse = HttpRequestService.sendPostRequest(
            'http://www.google.com',
            '{}'
        );
        HttpResponse response = new HttpRequestService()
            .method('POST')
            .endpoint('http://www.google.com')
            .timeout(999999)
            .headers(headers)
            .compressed(false)
            .body('{}')
            .queryParameters(queryParameters)
            .sendHttpRequest();

        Test.stopTest();

        System.assert(
            getResponse != null,
            'getResponse must return not null value'
        );
        System.assert(
            postResponse != null,
            'sendPostRequest must return not null value'
        );
        System.assert(
            response != null,
            'sendHttpRequest must return not null value'
        );
    }

    @isTest
    static void buildQueryParameterPath() {
        Map<String, Object> queryParameters = new Map<String, Object>();
        queryParameters.put('param1', 'value1');
        queryParameters.put('param2', '');
        queryParameters.put('', 'value3');

        String queryParameterPath = HttpRequestService.buildQueryParameterPath(
            queryParameters
        );

        System.assertEquals(
            '?param1=value1',
            queryParameterPath,
            'Should return the correct query parameter path'
        );
    }

    @isTest
    static void buildQueryParameterPathEmpty() {
        Map<String, Object> queryParameters = new Map<String, Object>();

        String queryParameterPath = HttpRequestService.buildQueryParameterPath(
            queryParameters
        );

        String queryParameterPath2 = HttpRequestService.buildQueryParameterPath(
            null
        );

        queryParameters.put('param2', '');
        queryParameters.put('', 'value3');

        String queryParameterPath3 = HttpRequestService.buildQueryParameterPath(
            queryParameters
        );

        System.assertEquals('', queryParameterPath, 'Should be empty');
        System.assertEquals('', queryParameterPath2, 'Should be empty');
        System.assertEquals('', queryParameterPath3, 'Should be empty');
    }

    @isTest
    static void invalidEndpoint() {
        Boolean hasException = false;

        try {
            Test.startTest();
            new HttpRequestService().sendHttpRequest();
            Test.stopTest();
        } catch (Exception e) {
            hasException = true;
        }

        System.assertEquals(
            true,
            hasException,
            'Should expect an exception since there is no endpoint'
        );
    }

    @isTest
    static void invalidMethod() {
        Boolean hasException = false;

        try {
            Test.startTest();
            new HttpRequestService().method('INVALID');
            Test.stopTest();
        } catch (Exception e) {
            hasException = true;
        }

        System.assertEquals(
            true,
            hasException,
            'Should expect an exception since the method is invalid'
        );
    }
}
