import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../persistence/MessageTemplatesMemoryPersistence.dart';
import '../persistence/MessageTemplatesFilePersistence.dart';
import '../persistence/MessageTemplatesMongoDbPersistence.dart';
import '../logic/MessageTemplatesController.dart';
import '../services/version1/MessageTemplatesHttpServiceV1.dart';

class MessageTemplatesServiceFactory extends Factory {
  static final MemoryPersistenceDescriptor = Descriptor(
      'pip-services-msgtemplates', 'persistence', 'memory', '*', '1.0');
  static final FilePersistenceDescriptor = Descriptor(
      'pip-services-msgtemplates', 'persistence', 'file', '*', '1.0');
  static final MongoDbPersistenceDescriptor = Descriptor(
      'pip-services-msgtemplates', 'persistence', 'mongodb', '*', '1.0');
  static final ControllerDescriptor = Descriptor(
      'pip-services-msgtemplates', 'controller', 'default', '*', '1.0');
  static final HttpServiceDescriptor =
      Descriptor('pip-services-msgtemplates', 'service', 'http', '*', '1.0');

  MessageTemplatesServiceFactory() : super() {
    registerAsType(MessageTemplatesServiceFactory.MemoryPersistenceDescriptor,
        MessageTemplatesMemoryPersistence);
    registerAsType(MessageTemplatesServiceFactory.FilePersistenceDescriptor,
        MessageTemplatesFilePersistence);
    registerAsType(MessageTemplatesServiceFactory.MongoDbPersistenceDescriptor,
        MessageTemplatesMongoDbPersistence);
    registerAsType(MessageTemplatesServiceFactory.ControllerDescriptor,
        MessageTemplatesController);
    registerAsType(MessageTemplatesServiceFactory.HttpServiceDescriptor,
        MessageTemplatesHttpServiceV1);
  }
}
