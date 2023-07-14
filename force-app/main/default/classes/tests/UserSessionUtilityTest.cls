/**
 * @description       : UserSessionUtility Tests
 * @author            : samuel@pipelaunch.com
 * @group             : Tests: Plugin Flow Lookup
 **/
@isTest
public with sharing class UserSessionUtilityTest {
    @isTest
    static void fetchUserSessionId() {
        Test.startTest();
        String sessionId = UserSessionUtility.fetchUserSessionId();
        Test.stopTest();

        System.assertEquals('test', sessionId, 'Session Id should be test');
    }
}
