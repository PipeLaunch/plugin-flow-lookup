/**
 * @description       : Callable class for Plugin Flow Lookup
 * @author            : samuel@pipelaunch.com
 * @group             : Plugin Flow Lookup
 * @last modified on  : 2023-06-27
 * @last modified by  : samuel@pipelaunch.com
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   2023-03-28   samuel@pipelaunch.com   Initial Version
 **/
@SuppressWarnings(
    'PMD.AvoidDebugStatements'
) // debug exceptions to see the trace
global class PluginFlowLookupCallable implements Callable {
    /**
     * @description Provides functionality that other classes or packages can utilize and build upon.
     * @author samuel@pipelaunch.com | 2023-03-28
     * @param action The behavior for the method to exhibit.
     * @param args Arguments to be used by the specified action.
     * @return Object The result of the method invocation.
     **/
    global Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'getListOfActiveFlows' {
                List<String> processTypes = (List<String>) args.get(
                    'processTypes'
                );
                Integer page = args.get('page') == null
                    ? 0
                    : (Integer) args.get('page');
                return PluginFlowLookupService.getListOfActiveFlows(
                    processTypes,
                    page
                );
            }
            when else {
                throw new IllegalArgumentException('Method not implemented');
            }
        }
    }
}
