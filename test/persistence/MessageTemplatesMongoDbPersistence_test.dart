import 'dart:io';
import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services_msgtemplates/pip_services_msgtemplates.dart';
import './MessageTemplatesPersistenceFixture.dart';

void main() {
  group('MessageTemplatesMongoDbPersistence', () {
    MessageTemplatesMongoDbPersistence persistence;
    MessageTemplatesPersistenceFixture fixture;

    setUp(() async {
      var mongoUri = Platform.environment['MONGO_SERVICE_URI'];
      var mongoHost = Platform.environment['MONGO_SERVICE_HOST'] ?? 'localhost';
      var mongoPort = Platform.environment['MONGO_SERVICE_PORT'] ?? '27017';
      var mongoDatabase = Platform.environment['MONGO_SERVICE_DB'] ?? 'test';
      var mongoCollection =
          Platform.environment['MONGO_COLLECTION'] ?? 'msgtemplates';
      // Exit if mongo connection is not set
      if (mongoUri == '' && mongoHost == '') return;

      var dbConfig = ConfigParams.fromTuples([
        'connection.uri',
        mongoUri,
        'connection.host',
        mongoHost,
        'connection.port',
        mongoPort,
        'connection.database',
        mongoDatabase,
        'collection',
        mongoCollection
      ]);

      persistence = MessageTemplatesMongoDbPersistence();
      persistence.configure(dbConfig);

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
