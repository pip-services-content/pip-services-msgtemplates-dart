# <img src="https://github.com/pip-services/pip-services/raw/master/design/Logo.png" alt="Pip.Services Logo" style="max-width:30%"> <br> MessageTemplates microservice

This is msgtemplates microservice from Pip.Services library. 
It shows to users inspirational msgtemplates on various topics.

The microservice currently supports the following deployment options:
* Deployment platforms: Standalone Process, Seneca
* External APIs: HTTP/REST, Seneca
* Persistence: Flat Files, MongoDB

This microservice has no dependencies on other microservices.

<a name="links"></a> Quick Links:

* [Download Links](doc/Downloads.md)
* [Development Guide](doc/Development.md)
* [Configuration Guide](doc/Configuration.md)
* [Deployment Guide](doc/Deployment.md)
* Client SDKs
  - [Node.js SDK](https://github.com/pip-services-users/pip-clients-msgtemplates-node)
  - [Dart SDK](https://github.com/pip-services-users/pip-clients-msgtemplates-dart)
* Communication Protocols
  - [HTTP Version 1](doc/HttpProtocolV1.md)

## Contract

Logical contract of the microservice is presented below. For physical implementation (HTTP/REST),
please, refer to documentation of the specific protocol.

```dart
class MessageTemplateV1 implements IStringIdentifiable {  
  String id;  
  String name;
  String from;
  MultiString subject;
  MultiString text;
  MultiString html;
  String status;
}

class MessageTemplateStatusV1 {
  static final New = 'new';
  static final Writing = 'writing';
  static final Translating = 'translating';
  static final Verifying = 'verifying';
  static final Completed = 'completed';
}

abstract class IMessageTemplatesV1 {
  Future<DataPage<TemplateV1>> getTemplates(
      String correlationId, FilterParams filter, PagingParams paging);

  Future<TemplateV1> getTemplateById(String correlationId, String id);

  Future<TemplateV1> getTemplateByIdOrName(String correlationId, String idOrName);

  Future<TemplateV1> createTemplate(String correlationId, TemplateV1 msgtemplate);

  Future<TemplateV1> updateTemplate(String correlationId, TemplateV1 msgtemplate);

  Future<TemplateV1> deleteTemplateById(String correlationId, String msgtemplateId);
}
```

## Download

Right now the only way to get the microservice is to check it out directly from github repository
```bash
git clone git@github.com:pip-services-content/pip-services-msgtemplates-dart.git
```

Pip.Service team is working to implement packaging and make stable releases available for your 
as zip downloadable archieves.

## Run

Add **config.yaml** file to the root of the microservice folder and set configuration parameters.

Example of microservice configuration
```yaml
---
# Container descriptor
- descriptor: "pip-services:context-info:default:default:1.0"
  name: "pip-services-msgtemplates"
  description: "Message Templates microservice for pip-services"

# Console logger
- descriptor: "pip-services:logger:console:default:1.0"
  level: "trace"

# Performance counters that posts values to log
- descriptor: "pip-services:counters:log:default:1.0"
  level: "trace"

{{#MEMORY_ENABLED}}
# In-memory persistence. Use only for testing!
- descriptor: "pip-services-msgtemplates:persistence:memory:default:1.0"
{{/MEMORY_ENABLED}}

{{#FILE_ENABLED}}
# File persistence. Use it for testing of for simple standalone deployments
- descriptor: "pip-services-msgtemplates:persistence:file:default:1.0"
  path: {{FILE_PATH}}{{^FILE_PATH}}"./data/msgtemplates.json"{{/FILE_PATH}}
{{/FILE_ENABLED}}

{{#MONGO_ENABLED}}
# MongoDB Persistence
- descriptor: "pip-services-msgtemplates:persistence:mongodb:default:1.0"
  collection: {{MONGO_COLLECTION}}{{^MONGO_COLLECTION}}msgtemplates{{/MONGO_COLLECTION}}
  connection:
    uri: {{{MONGO_SERVICE_URI}}}
    host: {{{MONGO_SERVICE_HOST}}}{{^MONGO_SERVICE_HOST}}localhost{{/MONGO_SERVICE_HOST}}
    port: {{MONGO_SERVICE_PORT}}{{^MONGO_SERVICE_PORT}}27017{{/MONGO_SERVICE_PORT}}
    database: {{MONGO_DB}}{{#^MONGO_DB}}app{{/^MONGO_DB}}
  credential:
    username: {{MONGO_USER}}
    password: {{MONGO_PASS}}
{{/MONGO_ENABLED}}

{{^MEMORY_ENABLED}}{{^FILE_ENABLED}}{{^MONGO_ENABLED}}
# Default in-memory persistence
- descriptor: "pip-services-msgtemplates:persistence:memory:default:1.0"
{{/MONGO_ENABLED}}{{/FILE_ENABLED}}{{/MEMORY_ENABLED}}

# Default controller
- descriptor: "pip-services-msgtemplates:controller:default:default:1.0"

# Common HTTP endpoint
- descriptor: "pip-services:endpoint:http:default:1.0"
  connection:
    protocol: "http"
    host: "0.0.0.0"
    port: 8080

# HTTP endpoint version 1.0
- descriptor: "pip-services-msgtemplates:service:http:default:1.0"

# Heartbeat service
- descriptor: "pip-services:heartbeat-service:http:default:1.0"

# Status service
- descriptor: "pip-services:status-service:http:default:1.0"
```
 
For more information on the microservice configuration see [Configuration Guide](doc/Configuration.md).

Start the microservice using the command:
```bash
dart ./bin/run.dart
```

## Use

The easiest way to work with the microservice is to use client SDK. 
The complete list of available client SDKs for different languages is listed in the [Quick Links](#links)

If you use dart, then get references to the required libraries:
- Pip.Services3.Commons : https://github.com/pip-services3-dart/pip-services3-commons-dart
- Pip.Services3.Rpc: 
https://github.com/pip-services3-dart/pip-services3-rpc-dart

Add **pip-services3-commons-dart**, **pip-services3-rpc-dart** and **pip-services_msgtemplates** packages
```dart
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

import 'package:pip_services_msgtemplates/pip_services_msgtemplates.dart';

```

Define client configuration parameters that match the configuration of the microservice's external API
```dart
// Client configuration
var httpConfig = ConfigParams.fromTuples(
	"connection.protocol", "http",
	"connection.host", "localhost",
	"connection.port", 8080
);
```

Instantiate the client and open connection to the microservice
```dart
// Create the client instance
var client = TemplatesHttpClientV1(config);

// Configure the client
client.configure(httpConfig);

// Connect to the microservice
try{
  await client.open(null)
}catch() {
  // Error handling...
}       
// Work with the microservice
// ...
```

Now the client is ready to perform operations
```dart
// Create a new msgtemplate
final TEMPLATE = MessageTemplateV1(
    id: '1',
    name: 'template1',
    from: null,
    subject: MultiString({ 'en': 'Text 1' }),
    text: MultiString({ 'en': 'Text 1' }),
    html: MultiString({ 'en': 'Text 1' }),
    status: MessageTemplateStatusV1.Completed);

    // Create the msgtemplate
    try {
      var msgtemplate = await client.createTemplate('123', TEMPLATE);
      // Do something with the returned msgtemplate...
    } catch(err) {
      // Error handling...     
    }
```

```dart
// Get the msgtemplate
try {
var msgtemplate = await client.getTemplateByIdOrName(
    null,
    'template1');
    // Do something with msgtemplate...

    } catch(err) { // Error handling}
```

## Acknowledgements

This microservice was created and currently maintained by
- **Sergey Seroukhov**
- **Nuzhnykh Egor**.
