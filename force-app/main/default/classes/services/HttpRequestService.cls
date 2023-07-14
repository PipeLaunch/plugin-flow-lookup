/**
 * @description       : HTTP Request Service
 *
 * @usage
 * Do a GET request with 120sec timeout (max) and without query parameters `HttpResponse response = HttpRequestService.sendGetRequest('https:api.sample.com',null);`
 * GET request with 30 sec timeout `HttpResponse response = new HttpRequestService().endpoint('https:api.sample.com').sendHttpRequest();`
 *
 * @author            : samuel@pipelaunch.com
 * @group             : HttpRequest Class
 * @last modified on  : 2023-07-14
 * @last modified by  : samuel@pipelaunch.com
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   2022-06-01   samuel@pipelaunch.com   Initial Version
 * 2.0   2022-12-09   samuel@pipelaunch.com   Use chainable methods
 * 2.1   2023-06-07   samuel@pipelaunch.com   Encode GET query parameters
 **/
@SuppressWarnings(
    'PMD.AvoidDebugStatements'
) // debug exceptions to see the trace
public with sharing class HttpRequestService {
    private String endpoint;
    private Map<String, String> headers;
    private String body;
    private Integer timeout = 120000;
    private String method = 'GET';
    private Map<String, Object> queryParameters;
    private Boolean compressed = false;

    /**
     * @description set the endpoint. Required
     * @author samuel@pipelaunch.com | 2022-12-09
     * @param value
     * @return HttpRequestService
     **/
    public HttpRequestService endpoint(String value) {
        this.endpoint = value;
        return this;
    }

    /**
     * @description set the header in a map key value pair. Default is null. See https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_http.htm for more details.
     * @author samuel@pipelaunch.com | 2022-12-09
     * @param value map of key value pair
     * @return HttpRequestService
     **/
    public HttpRequestService headers(Map<String, String> value) {
        this.headers = value;
        return this;
    }

    /**
     * @description set the request body. Default is null. See https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_http.htm for more details.
     * @author samuel@pipelaunch.com | 2022-12-09
     * @param value
     * @return HttpRequestService
     **/
    public HttpRequestService body(String value) {
        this.body = value;
        return this;
    }

    /**
     * @description set the request timeout in milliseconds. Default is 30000 (30 seconds). Max is 120000 (2 minutes). See https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_http.htm for more details.
     * @author samuel@pipelaunch.com | 2022-12-09
     * @param value in milliseconds
     * @return HttpRequestService
     **/
    public HttpRequestService timeout(Integer value) {
        this.timeout = validateTimeout(value);
        return this;
    }

    /**
     * @description set the request method. Default is GET. Allowed methods are GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS, TRACE, CONNECT, MERGE, PURGE, COPY, LOCK, UNLOCK, PROPFIND, VIEW, and LINK. See https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_http.htm for more details.
     * @author samuel@pipelaunch.com | 2022-12-09
     * @param value
     * @return HttpRequestService
     **/
    public HttpRequestService method(String value) {
        if (hasInvalidMethod(value)) {
            throw new IllegalArgumentException('Invalid method: ' + value);
        }

        this.method = value;
        return this;
    }

    /**
     * @description add query parameters to the request
     * @author samuel@pipelaunch.com | 2022-12-09
     * @param value
     * @return HttpRequestService
     **/
    public HttpRequestService queryParameters(Map<String, Object> value) {
        this.queryParameters = value;
        return this;
    }

    /**
     * @description set compressed to true to compress the request body. Default is false.
     * @author samuel@pipelaunch.com | 2022-12-09
     * @param value
     * @return HttpRequestService
     **/
    public HttpRequestService compressed(Boolean value) {
        this.compressed = value;
        return this;
    }

    /**
     * @description call this method to send the request
     * @author samuel@pipelaunch.com | 2022-12-09
     * @return HttpResponse
     **/
    public HttpResponse sendHttpRequest() {
        if (String.isBlank(this.endpoint)) {
            throw new IllegalArgumentException('empty endpoint');
        }

        String endPoint = buildEndpoint(this.endpoint, this.queryParameters);
        // System.debug(LoggingLevel.INFO, 'Endpoint: ' + endPoint);

        HttpRequest httpRequest = new HttpRequest();

        httpRequest.setMethod(this.method);
        httpRequest.setEndpoint(endPoint);
        httpRequest.setTimeout(this.timeout);
        httpRequest.setCompressed(this.compressed);

        if (String.isNotBlank(this.body)) {
            httpRequest.setBody(this.body);
        }

        if (this.headers != null && !this.headers.isEmpty()) {
            for (String header : this.headers.keySet()) {
                httpRequest.setHeader(header, this.headers.get(header));
            }
        }

        Http http = new http();
        HttpResponse httpResponse = http.send(httpRequest);

        return httpResponse;
    }

    /**
     * @description send default GET request with query parameters and default timeout of 2 minutes
     * @author samuel@pipelaunch.com | 25-08-2022
     * @param endPoint
     * @param queryParameters a list of query parameters
     * @return HttpResponse
     **/
    public static HttpResponse sendGetRequest(
        String endPoint,
        Map<String, Object> queryParameters
    ) {
        return new HttpRequestService()
            .endpoint(endPoint)
            .timeout(120000)
            .method('GET')
            .queryParameters(queryParameters)
            .sendHttpRequest();
    }

    /**
     * @description send default POST request with body and default timeout of 2 minutes
     * @author samuel@pipelaunch.com | 25-08-2022
     * @param endPoint
     * @param body usally a JSON string
     * @return HttpResponse
     **/
    public static HttpResponse sendPostRequest(String endPoint, String body) {
        return new HttpRequestService()
            .endpoint(endPoint)
            .timeout(120000)
            .method('POST')
            .body(body)
            .sendHttpRequest();
    }

    /**
     * @description Create ?test=value query string parameters from map
     * @param valueByName
     * @return String
     **/
    @TestVisible
    private static String buildQueryParameterPath(
        Map<String, Object> valueByName
    ) {
        if (valueByName == null || valueByName.isEmpty()) {
            return '';
        }

        List<String> pairs = new List<String>();

        for (String name : valueByName.keySet()) {
            if (String.isBlank(name)) {
                continue;
            }

            String value = valueByName.get(name) == null
                ? ''
                : String.valueOf(valueByName.get(name));

            if (String.isBlank(value)) {
                continue;
            }

            pairs.add(
                name + '=' + System.EncodingUtil.urlEncode(value, 'UTF-8')
            );
        }

        if (pairs.isEmpty()) {
            return '';
        }

        return '?' + String.join(pairs, '&');
    }

    /**
     * @description build endpoint url with query parameters
     * @param endpoint
     * @param queryParameters
     * @return String
     **/
    @TestVisible
    private static String buildEndpoint(
        String endpoint,
        Map<String, Object> queryParameters
    ) {
        String query = queryParameters != null && !queryParameters.isEmpty()
            ? buildQueryParameterPath(queryParameters)
            : '';
        // System.debug(LoggingLevel.INFO, query);
        return endPoint + query;
    }

    /**
     * @description Validate timeout parameter. Needs to be a value between 1 and 120 seconds.
     * @param timeout input value
     * @return Integer validated value
     **/
    private static Integer validateTimeout(Integer timeout) {
        if (timeout == null || timeout <= 0 || timeout > 120000) {
            timeout = 30000; // 30 seconds default
        }
        return timeout;
    }

    /**
     * @description validates http method
     * @param method method to validate
     * @return Boolean true if method is invalid
     **/
    private static Boolean hasInvalidMethod(String method) {
        List<String> validMethods = new List<String>{
            'GET',
            'POST',
            'PUT',
            'DELETE',
            'PATCH',
            'TRACE'
        };

        return String.isBlank(method) || !validMethods.contains(method);
    }
}
