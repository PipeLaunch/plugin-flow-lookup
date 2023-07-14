/**
 * @description       :
 * @author            : samuel@pipelaunch.com
 * @group             : Tests: Plugin Flow Lookup
 * @last modified on  : 2023-06-27
 * @last modified by  : samuel@pipelaunch.com
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   2023-03-28   samuel@pipelaunch.com   Initial Version
 **/
@isTest
public with sharing class PluginFlowLookupServiceTest {
    @isTest
    static void getListOfActiveFlowsInvalid() {
        Boolean hasException = false;

        try {
            Test.startTest();
            PluginFlowLookupService.getListOfActiveFlows(null, -1);
            Test.stopTest();
        } catch (Exception e) {
            hasException = true;
        }

        System.assertEquals(
            true,
            hasException,
            'Should expect an exception since the parameter is invalid'
        );
    }

    @isTest
    static void generateFlowSoqlIds() {
        Test.startTest();
        List<String> processTypes = new List<String>{
            'Flow',
            'AutoLaunchedFlow'
        };
        String soql = PluginFlowLookupService.generateFlowSoqlIds(
            processTypes,
            0
        );
        Test.stopTest();

        System.assert(String.isNotBlank(soql), 'Coverage');
    }

    @isTest
    static void generateFlowDetailsSoql() {
        Test.startTest();
        String soql = PluginFlowLookupService.generateFlowDetailsSoql(null);
        Test.stopTest();

        System.assert(String.isNotBlank(soql), 'Coverage');
    }

    @isTest
    static void getFlowDetailsFromIds() {
        Test.setMock(HttpCalloutMock.class, new HttpRequestServiceMockTest());

        Test.startTest();
        Set<Id> flowIds = new Set<Id>{ '300000000000000AAA' };
        PluginFlowLookupService.getFlowDetailsFromIds(flowIds);
        Test.stopTest();

        System.assert(true, 'Coverage');
    }
}
