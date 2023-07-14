/**
 * @description       : Config values
 * @author            : samuel@pipelaunch.com
 * @group             : PluginFlowLookup
 * @last modified on  : 2023-06-27
 * @last modified by  : samuel@pipelaunch.com
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   2023-06-27   samuel@pipelaunch.com   Initial Version
 **/
public with sharing class PluginFlowLookupConfig {
    /**
     * @description Limit of flows per "batch" limited by callout limits
     */
    public static final Integer BATCH_LIMIT = 99;

    /**
     * @description API Version to use for the Tooling API
     */
    public static final String API_VERSION = 'v57.0';

    /**
     * @description Default fields to return from the Flow Object
     */
    public static final List<String> FLOW_DETAILS_FIELDS = new List<String>{
        'Id',
        'FullName',
        'Description',
        'MasterLabel',
        'VersionNumber'
    };
}
