import 'package:pip_services3_rpc/pip_services3_rpc.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

class MessageTemplatesHttpServiceV1 extends CommandableHttpService {
  MessageTemplatesHttpServiceV1() : super('v1/message_templates') {
    dependencyResolver.put('controller',
        Descriptor('pip-services-msgtemplates', 'controller', '*', '*', '1.0'));
  }
}
