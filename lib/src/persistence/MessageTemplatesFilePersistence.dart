import 'package:pip_services3_data/pip_services3_data.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../data/version1/MessageTemplateV1.dart';
import './MessageTemplatesMemoryPersistence.dart';

class MessageTemplatesFilePersistence
    extends MessageTemplatesMemoryPersistence {
  JsonFilePersister<MessageTemplateV1> persister;

  MessageTemplatesFilePersistence([String path]) : super() {
    persister = JsonFilePersister<MessageTemplateV1>(path);
    loader = persister;
    saver = persister;
  }
  @override
  void configure(ConfigParams config) {
    super.configure(config);
    persister.configure(config);
  }
}
