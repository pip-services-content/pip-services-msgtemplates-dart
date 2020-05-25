import 'package:pip_services3_container/pip_services3_container.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

import '../build/MessageTemplatesServiceFactory.dart';

class MessageTemplatesProcess extends ProcessContainer {
  MessageTemplatesProcess()
      : super('message_templates', 'Message templates microservice') {
    factories.add(MessageTemplatesServiceFactory());
    factories.add(DefaultRpcFactory());
  }
}
