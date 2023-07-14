# Plugin: Flow Lookup

Open-source Plugin to get access to the list of active flows in your org from the lightning context.

## Motivation

This plugin was created due to the limitations of accessing the tooling API from lightning context and getting the flow metadata values. This plugin uses the following 'hacks' to get the list of active flows:

-   get UserSessionId from the VisualForce page context
-   does an API call to the tooling API to get the list of active flows
-   does another individual API call to iterate over all the flows and get the metadata values

## How to use it

### Install the unlocked package

[![Install package](salesforce-package-installation.png)](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t09000000S8DzAAK)

https://login.salesforce.com/packaging/installPackage.apexp?p0=04t09000000S8DzAAK

or

<a href="https://githubsfdeploy.herokuapp.com?owner=PipeLaunch&repo=plugin-flow-lookup&ref=main">
    <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

### Use the plugin in your code

```java
Callable pluginFlowLookupCall = (Callable) Type.forName('PluginFlowLookupCallable')
    .newInstance();

List<String> processTypes = new List<String>{ 'Flow', 'AutoLaunchedFlow' };
Map<String, Object> result = (Map<String, Object>) pluginFlowLookupCall.call(
    'getListOfActiveFlows',
    new Map<String, Object>{ 'processTypes' => processTypes, 'page' => 0  }
);

System.debug(LoggingLevel.INFO, JSON.serializePretty(result));
```

Sample output:

```json
{
    "results": [
        {
            "VersionNumber": 1,
            "MasterLabel": "screen flow",
            "Description": null,
            "FullName": "screen_flow",
            "Id": "11111",
            "attributes": {
                "url": "/services/data/v57.0/tooling/sobjects/Flow/11111",
                "type": "Flow"
            }
        },
        {
            "VersionNumber": 1,
            "MasterLabel": "screen flow 2",
            "Description": "this is a screen flow description",
            "FullName": "screen_flow_2",
            "Id": "22222",
            "attributes": {
                "url": "/services/data/v57.0/tooling/sobjects/Flow/2222",
                "type": "Flow"
            }
        },
        {
            "VersionNumber": 2,
            "MasterLabel": "autolaunched flow",
            "Description": "My description",
            "FullName": "autolaunched_flow",
            "Id": "3333",
            "attributes": {
                "url": "/services/data/v57.0/tooling/sobjects/Flow/3333",
                "type": "Flow"
            }
        }
    ],
    "page": 0,
    "total": 3,
    "statusCode": 200
}
```

### Configuration

Browse the content of the file `PluginFlowLookupConfig.cls`.

### Create new version

-   Bump the version in `sfdx-project.json`. E.g. `"versionNumber": "1.2.0.NEXT"` -> `"versionNumber": "1.3.0.NEXT"`
-   Run the `createversion.sh` script
-   Wait until a new version is created
-   Update the `promoteversion.sh` script with the new version number
-   Run the `promoteversion.sh` script (otherwise beta package cannot be installed in production)
