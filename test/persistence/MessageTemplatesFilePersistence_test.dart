import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services_msgtemplates/pip_services_msgtemplates.dart';
import './MessageTemplatesPersistenceFixture.dart';

void main() {
  group('MessageTemplatesFilePersistence', () {
    MessageTemplatesFilePersistence persistence;
    MessageTemplatesPersistenceFixture fixture;

    setUp(() async {
      persistence =
          MessageTemplatesFilePersistence('data/msgtemplates.test.json');
      persistence.configure(ConfigParams());

      fixture = MessageTemplatesPersistenceFixture(persistence);

      await persistence.open(null);
      await persistence.clear(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('CRUD Operations', () async {
      await fixture.testCrudOperations();
    });

    test('Get with Filters', () async {
      await fixture.testGetWithFilters();
    });
  });
}
