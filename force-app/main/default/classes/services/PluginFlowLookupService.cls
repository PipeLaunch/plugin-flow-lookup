/**
 * @description       : Plugin Flow Lookup Main service class
 * @author            : samuel@pipelaunch.com
 * @group             : Plugin Flow Lookup
 * @last modified on  : 2023-07-14
 * @last modified by  : samuel@pipelaunch.com
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   2023-03-28   samuel@pipelaunch.com   Initial Version
 **/
@SuppressWarnings(
    'PMD.AvoidDebugStatements'
) // debug exceptions to see the trace
public with sharing class PluginFlowLookupService {
    /**
     * @description get all active flows with the 'hack' of doing a query on the tooling api
     *
     * @author samuel@pipelaunch.com | 11-30-2022
     * @param processTypes Flow or AutoLaunchedFlow, etc.
     * @param page the page to use for the query offset
     * @return Map<String, Object>
     * @example
     * Returns a list of active flows with the following structure:
     * `{results=[], statusCode=200, total=0, page=0}`
     **/
    public static Map<String, Object> getListOfActiveFlows(
        List<String> processTypes,
        Integer page
    ) {
        if (processTypes.isEmpty() || page == null || page < 0) {
            throw new IllegalArgumentException('Invalid arguments');
        }

        // get the list of Ids of the active flows
        HttpResponse res = getListOfActiveFlowsFromToolingApi(
            processTypes,
            page
        );

        // generate a list of Ids from the response. Use it to count the number of flows
        // and paginate at the frontend
        Set<Id> flowIds = parseIdResults(res);

        if (flowIds.isEmpty()) {
            return new Map<String, Object>{
                'statusCode' => 200,
                'total' => 0,
                'page' => page,
                'results' => new List<Object>()
            };
        }

        // query the details of the each flow
        List<Object> flows = getFlowDetailsFromIds(flowIds);

        return new Map<String, Object>{
            'statusCode' => 200,
            'total' => flowIds.size(),
            'page' => page,
            'results' => flows
        };
    }

    /**
     * @description get flow details required because
     * When retrieving results with Metadata or FullName fields, the query qualificatio​ns must specify no more than one row for retrieval.
     * @author samuel@pipelaunch.com | 2023-06-27
     * @param flowIds
     * @return List<Object>
     **/
    @TestVisible
    private static List<Object> getFlowDetailsFromIds(Set<Id> flowIds) {
        List<Object> results = new List<Object>();

        for (Integer i = 0; i < PluginFlowLookupConfig.BATCH_LIMIT; i++) {
            if (i >= flowIds.size()) {
                break;
            }

            // WARNING: due to the limitation of the tooling API we need to do a dangerous
            // SOQL inside a loop over all the flow Ids
            Object flowDetails = getFlowDetailsFromId(
                (new List<Id>(flowIds))[i]
            );

            if (flowDetails != null) {
                // System.debug(JSON.serializePretty(flowDetails));
                results.add(flowDetails);
            }
        }

        return results;
    }

    private static Object getFlowDetailsFromId(Id flowId) {
        HttpResponse res = getFlowDetailsFromToolingApi(flowId);

        return parseFlowDetailsResults(res);
    }

    private static Object parseFlowDetailsResults(HttpResponse res) {
        if (res.getStatusCode() != 200) {
            System.debug(
                LoggingLevel.ERROR,
                'Invalid response from flow details: ' + res.getStatusCode()
            );
            throw new CalloutException();
        }

        Map<String, Object> resultJSON = (Map<String, Object>) JSON.deserializeUntyped(
            res.getBody()
        );
        if (resultJSON == null || resultJSON.isEmpty()) {
            return null;
        }

        List<Object> records = (List<Object>) resultJSON.get('records');
        return records[0];
    }

    private static HttpResponse getFlowDetailsFromToolingApi(Id flowId) {
        Map<String, String> queryParameters = new Map<String, String>{
            'q' => generateFlowDetailsSoql(flowId)
        };

        return PluginFlowLookupUtility.getDataFromToolingApi(queryParameters);
    }

    /**
     * @description generate a list of Ids from the response
     * @author samuel@pipelaunch.com | 2023-06-27
     * @param res
     * @return Set<Id>
     **/
    private static Set<Id> parseIdResults(HttpResponse res) {
        if (res.getStatusCode() != 200) {
            System.debug(
                LoggingLevel.ERROR,
                'Invalid response: ' + res.getStatusCode()
            );
            throw new CalloutException();
        }

        Map<String, Object> resultJSON = (Map<String, Object>) JSON.deserializeUntyped(
            res.getBody()
        );

        Set<Id> results = new Set<Id>();

        if (resultJSON == null || resultJSON.isEmpty()) {
            return results;
        }

        for (Object result : (List<Object>) resultJSON.get('records')) {
            results.add((Id) ((Map<String, Object>) result).get('Id'));
        }

        return results;
    }

    private static HttpResponse getListOfActiveFlowsFromToolingApi(
        List<String> processTypes,
        Integer page
    ) {
        Integer offset = page * PluginFlowLookupConfig.BATCH_LIMIT;
        Map<String, String> queryParameters = new Map<String, String>{
            'q' => generateFlowSoqlIds(processTypes, offset)
        };

        return PluginFlowLookupUtility.getDataFromToolingApi(queryParameters);
    }

    @TestVisible
    private static String generateFlowSoqlIds(
        List<String> processTypes,
        Integer offset
    ) {
        List<String> soql = new List<String>();
        soql.add('SELECT Id');
        soql.add('FROM Flow');
        soql.add('WHERE');
        soql.add(
            'processType IN ' +
            PluginFlowLookupUtility.generateListClause(processTypes)
        );
        soql.add('AND');
        soql.add('Status = \'Active\'');
        // soql.add('WITH SECURITY_ENFORCED'); // not allowed in this context
        soql.add('LIMIT 4000'); // https://help.salesforce.com/s/articleView?id=sf.flow_considerations_limit.htm&type=5 (see the 'Limitations' section)
        soql.add('OFFSET ' + offset);

        String queryString = String.join(soql, ' ');
        // System.debug(LoggingLevel.DEBUG, 'Flow Ids dynamic query: ' + queryString);
        return queryString;
    }

    @TestVisible
    private static String generateFlowDetailsSoql(Id flowId) {
        List<String> soql = new List<String>();
        soql.add('SELECT');
        soql.add(String.join(PluginFlowLookupConfig.FLOW_DETAILS_FIELDS, ', '));
        soql.add('FROM Flow');
        soql.add('WHERE');
        soql.add('Id = \'' + flowId + '\'');

        String queryString = String.join(soql, ' ');
        // System.debug(
        //     LoggingLevel.DEBUG,
        //     'generateFlowDetailsSoql: ' + queryString
        // );
        return queryString;
    }
}
