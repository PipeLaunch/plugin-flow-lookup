/**
 * @description       : General utilities
 * @author            : samuel@pipelaunch.com
 * @group             : Plugin Flow Lookup
 * @last modified on  : 2023-06-27
 * @last modified by  : samuel@pipelaunch.com
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   2023-06-27   samuel@pipelaunch.com   Initial Version
 **/
public with sharing class PluginFlowLookupUtility {
    private static String memoizedUserInfo = null;

    /**
     * @description
     * @author samuel@pipelaunch.com | 2023-06-27
     * @param processTypes
     * @return String
     **/
    public static String generateListClause(List<String> processTypes) {
        List<String> processes = new List<String>();
        for (String processType : processTypes) {
            processes.add(String.escapeSingleQuotes(processType));
        }

        String processTypeClause =
            '(\'' +
            String.join(processes, '\',\'') +
            '\')';

        return processTypeClause;
    }

    /**
     * @description
     * @author samuel@pipelaunch.com | 2023-06-27
     * @param queryParameters
     * @return HttpResponse
     **/
    public static HttpResponse getDataFromToolingApi(
        Map<String, String> queryParameters
    ) {
        HttpResponse res = new HttpRequestService()
            .endpoint(generateToolingApiUrl())
            .headers(
                new Map<String, String>{
                    'Authorization' => 'Bearer ' + getSessionId()
                }
            )
            .queryParameters(queryParameters)
            .sendHttpRequest();

        return res;
    }

    @TestVisible
    private static String generateToolingApiUrl() {
        return System.Url.getSalesforceBaseUrl().toExternalForm() +
            '/services/data/' +
            PluginFlowLookupConfig.API_VERSION +
            '/tooling/query';
    }

    // need the session id to make the callout. Only the 'hack' with using
    // a visualforce page to get the session id works from a lightning context
    @TestVisible
    private static String getSessionId() {
        if (memoizedUserInfo != null) {
            return memoizedUserInfo;
        }

        memoizedUserInfo = UserSessionUtility.fetchUserSessionId();

        return memoizedUserInfo;
        // return UserInfo.getSessionId();
        // return System.Page.session.getContent().toString().trim();
    }
}
