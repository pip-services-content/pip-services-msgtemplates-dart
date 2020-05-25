import 'package:test/test.dart';
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
final TEMPLATE3 = MessageTemplateV1(
    id: '3',
    name: 'template3',
    from: null,
    subject: MultiString({'en': 'Text 2'}),
    text: MultiString({'en': 'Text 2'}),
    html: MultiString({'en': 'Text 2'}),
    status: MessageTemplateStatusV1.Translating);

class MessageTemplatesPersistenceFixture {
  IMessageTemplatesPersistence _persistence;

  MessageTemplatesPersistenceFixture(IMessageTemplatesPersistence persistence) {
    expect(persistence, isNotNull);
    _persistence = persistence;
  }

  void _testCreateMessageTemplates() async {
    // Create the first msgtemplate
    var msgtemplate = await _persistence.create(null, TEMPLATE1);

    expect(msgtemplate, isNotNull);
    expect(TEMPLATE1.id, msgtemplate.id);
    expect(TEMPLATE1.name, msgtemplate.name);
    expect(TEMPLATE1.status, msgtemplate.status);
    expect(TEMPLATE1.text.get('en'), msgtemplate.text.get('en'));

    // Create the second msgtemplate
    msgtemplate = await _persistence.create(null, TEMPLATE2);
    expect(msgtemplate, isNotNull);
    expect(TEMPLATE2.id, msgtemplate.id);
    expect(TEMPLATE2.name, msgtemplate.name);
    expect(TEMPLATE2.status, msgtemplate.status);
    expect(TEMPLATE2.text.get('en'), msgtemplate.text.get('en'));

    // Create the third msgtemplate
    msgtemplate = await _persistence.create(null, TEMPLATE3);
    expect(msgtemplate, isNotNull);
    expect(TEMPLATE3.id, msgtemplate.id);
    expect(TEMPLATE3.name, msgtemplate.name);
    expect(TEMPLATE3.status, msgtemplate.status);
    expect(TEMPLATE3.text.get('en'), msgtemplate.text.get('en'));
  }

  void testCrudOperations() async {
    MessageTemplateV1 msgtemplate1;

    // Create items
    await _testCreateMessageTemplates();

    // Get all msgtemplates
    var page = await _persistence.getPageByFilter(
        null, FilterParams(), PagingParams());
    expect(page, isNotNull);
    expect(page.data.length, 3);

    msgtemplate1 = page.data[0];

    // Update the msgtemplate
    msgtemplate1.text = MultiString({'en': 'Updated Content 1'});

    var msgtemplate = await _persistence.update(null, msgtemplate1);
    expect(msgtemplate, isNotNull);
    expect(msgtemplate1.id, msgtemplate.id);
    expect('Updated Content 1', msgtemplate.text.get('en'));

    // Get msgtemplate by name
    msgtemplate = await _persistence.getOneByIdOrName(null, msgtemplate1.name);
    expect(msgtemplate, isNotNull);
    expect(msgtemplate1.id, msgtemplate.id);

    // Delete the msgtemplate
    msgtemplate = await _persistence.deleteById(null, msgtemplate1.id);
    expect(msgtemplate, isNotNull);
    expect(msgtemplate1.id, msgtemplate.id);

    // Try to get deleted msgtemplate
    msgtemplate = await _persistence.getOneById(null, msgtemplate1.id);
    expect(msgtemplate, isNull);
  }

  void testGetWithFilters() async {
    // Create items
    await _testCreateMessageTemplates();

    // Get msgtemplate filtered by name
    var page = await _persistence.getPageByFilter(
        null, FilterParams.fromValue({'name': TEMPLATE1.name}), PagingParams());
    expect(page, isNotNull);
    expect(page.data.length, 1);

    // Get msgtemplate by substring
    page = await _persistence.getPageByFilter(
        null, FilterParams.fromValue({'search': 'temp'}), PagingParams());
    expect(page, isNotNull);
    expect(page.data.length, 3);

    // Get msgtemplate by status
    page = await _persistence.getPageByFilter(null,
        FilterParams.fromValue({'status': TEMPLATE3.status}), PagingParams());
    expect(page, isNotNull);
    expect(page.data.length, 1);
  }
}
