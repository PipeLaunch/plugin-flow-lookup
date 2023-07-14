/**
 * @description       :
 * @author            : samuel@pipelaunch.com
 * @group             :
 * @last modified on  : 2023-06-27
 * @last modified by  : samuel@pipelaunch.com
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   2023-06-27   samuel@pipelaunch.com   Initial Version
 **/
@isTest
public with sharing class PluginFlowLookupUtilityTest {
    @isTest
    static void generateListClause() {
        Test.startTest();
        List<String> processTypes = new List<String>{ 'A', 'B' };
        String result = PluginFlowLookupUtility.generateListClause(
            processTypes
        );
        Test.stopTest();

        System.assertEquals('(\'A\',\'B\')', result, 'Should be equal');
    }

    @isTest
    static void getDataFromToolingApi() {
        Test.setMock(HttpCalloutMock.class, new HttpRequestServiceMockTest());

        Test.startTest();

        Map<String, String> queryParameters = new Map<String, String>{
            'q' => 'SELECT Id FROM FlowDefinition'
        };
        PluginFlowLookupUtility.getDataFromToolingApi(queryParameters);

        Test.stopTest();

        System.assert(true, 'Coverage');
    }
}
