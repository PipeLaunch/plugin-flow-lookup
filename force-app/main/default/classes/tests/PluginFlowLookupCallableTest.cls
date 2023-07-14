/**
 * @description       : Test class for PluginFlowLookupCallable
 * @author            : samuel@pipelaunch.com
 * @group             : Tests: Plugin Flow Lookup
 * @last modified on  : 2023-06-27
 * @last modified by  : samuel@pipelaunch.com
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   2023-03-28   samuel@pipelaunch.com   Initial Version
 **/
@isTest
public with sharing class PluginFlowLookupCallableTest {
    @isTest
    static void call() {
        Test.setMock(HttpCalloutMock.class, new HttpRequestServiceMockTest());

        Test.startTest();

        Callable pluginFlowLookupCall = (Callable) Type.forName(
                'PluginFlowLookupCallable'
            )
            .newInstance();

        List<String> processTypes = new List<String>{
            'Flow',
            'AutoLaunchedFlow'
        };

        Map<String, Object> result = (Map<String, Object>) pluginFlowLookupCall.call(
            'getListOfActiveFlows',
            new Map<String, Object>{
                'processTypes' => processTypes,
                'page' => 0
            }
        );

        Test.stopTest();

        System.assertEquals(
            200,
            result.get('statusCode'),
            'Status code should be 200'
        );
    }

    @isTest
    static void callInvalid() {
        Boolean hasException = false;

        try {
            Test.startTest();

            Callable pluginFlowLookupCall = (Callable) Type.forName(
                    'PluginFlowLookupCallable'
                )
                .newInstance();

            pluginFlowLookupCall.call('invalid', new Map<String, Object>());

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
}
