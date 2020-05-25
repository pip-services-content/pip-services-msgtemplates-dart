# Examples for MessageTemplates microservice

This is msgtemplates microservice from Pip.Services library. 
It shows to users inspirational msgtemplates on various topics.

Define configuration parameters that match the configuration of the microservice's external API
```dart
// Service/Client configuration
var httpConfig = ConfigParams.fromTuples(
	"connection.protocol", "http",
	"connection.host", "localhost",
	"connection.port", 8080
);
```

Instantiate the service
```dart
persistence = MessageTemplatesMemoryPersistence();
persistence.configure(ConfigParams());

controller = MessageTemplatesController();
controller.configure(ConfigParams());

service = MessageTemplatesHttpServiceV1();
service.configure(httpConfig);

var references = References.fromTuples([
    Descriptor('pip-services-msgtemplates', 'persistence', 'memory',
        'default', '1.0'),
    persistence,
    Descriptor('pip-services-msgtemplates', 'controller', 'default',
        'default', '1.0'),
    controller,
    Descriptor(
        'pip-services-msgtemplates', 'service', 'http', 'default', '1.0'),
    service
]);

controller.setReferences(references);
service.setReferences(references);

await persistence.open(null);
await service.open(null);
```

Instantiate the client and open connection to the microservice
```dart
// Create the client instance
var client = MessageTemplatesHttpClientV1(config);

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

In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services-content/pip-services-msgtemplates-dart/tree/master/test).
