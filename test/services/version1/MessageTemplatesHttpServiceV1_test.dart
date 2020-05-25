import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_msgtemplates/pip_services_msgtemplates.dart';

final TEMPLATE1 = MessageTemplateV1(
    id: '1',
    name: 'template1',
    from: null,
    subject: MultiString({'en': 'Text 1'}),
    text: MultiString({'en': 'Text 1'}),
    html: MultiString({'en': 'Text 1'}),
    status: MessageTemplateStatusV1.Completed);
final TEMPLATE2 = MessageTemplateV1(
    id: '2',
    name: 'template2',
    from: null,
    subject: MultiString({'en': 'Text 2'}),
    text: MultiString({'en': 'Text 2'}),
    html: MultiString({'en': 'Text 2'}),
    status: MessageTemplateStatusV1.Completed);

var httpConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3000
]);

void main() {
  group('MessageTemplatesHttpServiceV1', () {
    MessageTemplatesMemoryPersistence persistence;
    MessageTemplatesController controller;
    MessageTemplatesHttpServiceV1 service;
    http.Client rest;
    String url;

    setUp(() async {
      url = 'http://localhost:3000';
      rest = http.Client();

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
    });

    tearDown(() async {
      await service.close(null);
      await persistence.close(null);
    });

    test('CRUD Operations', () async {
      MessageTemplateV1 msgtemplate1;

      // Create the first msgtemplate
      var resp = await rest.post(url + '/v1/message_templates/create_template',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'template': TEMPLATE1}));
      var msgtemplate = MessageTemplateV1();
      msgtemplate.fromJson(json.decode(resp.body));
      expect(msgtemplate, isNotNull);
      expect(TEMPLATE1.id, msgtemplate.id);
      expect(TEMPLATE1.name, msgtemplate.name);
      expect(TEMPLATE1.text.get('en'), msgtemplate.text.get('en'));

      // Create the second msgtemplate
      resp = await rest.post(url + '/v1/message_templates/create_template',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'template': TEMPLATE2}));
      msgtemplate = MessageTemplateV1();
      msgtemplate.fromJson(json.decode(resp.body));
      expect(msgtemplate, isNotNull);
      expect(TEMPLATE2.id, msgtemplate.id);
      expect(TEMPLATE2.name, msgtemplate.name);
      expect(TEMPLATE2.text.get('en'), msgtemplate.text.get('en'));

      // Get all msgtemplates
      resp = await rest.post(url + '/v1/message_templates/get_templates',
          headers: {'Content-Type': 'application/json'},
          body: json
              .encode({'filter': FilterParams(), 'paging': PagingParams()}));
      var page =
          DataPage<MessageTemplateV1>.fromJson(json.decode(resp.body), (item) {
        var msgtemplate = MessageTemplateV1();
        msgtemplate.fromJson(item);
        return msgtemplate;
      });
      expect(page, isNotNull);
      expect(page.data.length, 2);

      msgtemplate1 = page.data[0];

      // Update the msgtemplate
      msgtemplate1.text = MultiString({'en': 'Updated Content 1'});

      resp = await rest.post(url + '/v1/message_templates/update_template',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'template': msgtemplate1}));
      msgtemplate = MessageTemplateV1();
      msgtemplate.fromJson(json.decode(resp.body));
      expect(msgtemplate, isNotNull);
      expect(msgtemplate1.id, msgtemplate.id);
      expect('Updated Content 1', msgtemplate.text.get('en'));

      // Delete the msgtemplate
      resp = await rest.post(
          url + '/v1/message_templates/delete_template_by_id',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'template_id': msgtemplate1.id}));
      msgtemplate = MessageTemplateV1();
      msgtemplate.fromJson(json.decode(resp.body));
      expect(msgtemplate, isNotNull);
      expect(msgtemplate1.id, msgtemplate.id);

      // Try to get deleted msgtemplate
      resp = await rest.post(url + '/v1/message_templates/get_template_by_id',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'template_id': msgtemplate1.id}));
      expect(resp.body, isEmpty);
    });
  });
}
