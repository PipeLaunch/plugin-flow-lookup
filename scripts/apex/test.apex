String extensionClass = 'PluginFlowLookupCallable';

List<String> processTypes = new List<String>{ 'Flow', 'AutoLaunchedFlow' };

Callable call1 = (Callable) Type.forName(extensionClass).newInstance();
Map<String, Object> result1 = (Map<String, Object>) call1.call(
    'getListOfActiveFlows',
    new Map<String, Object>{ 'processTypes' => processTypes, 'page' => 0 }
);

// create some flows to test
System.debug(JSON.serializePretty(result1));
