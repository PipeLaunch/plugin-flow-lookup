/**
 * @description       : Get the user session Id useful to do a callout to Salesforce REST API
 * @author            : samuel@pipelaunch.com
 * @group             : Utilities
 * @last modified on  : 2022-12-08
 * @last modified by  : samuel@pipelaunch.com
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   2022-12-01   samuel@pipelaunch.com   Initial Version
 **/
public with sharing class UserSessionUtility {
    /**
     * @description 'hack' to fetch the user's session id from the lightning context
     * @author samuel@pipelaunch.com | 2022-12-01
     * @return String
     **/
    public static String fetchUserSessionId() {
        PageReference sessionIdPage = Page.UserSessionPage;

        String vfContent = Test.isRunningTest()
            ? '[[test]]'
            : sessionIdPage.getContent().toString();

        Integer startPosition = vfContent.indexOf('[[') + 2;
        Integer endPosition = vfContent.indexOf(']]');
        String sSessionId = vfContent.substring(startPosition, endPosition);

        return sSessionId;
    }
}
