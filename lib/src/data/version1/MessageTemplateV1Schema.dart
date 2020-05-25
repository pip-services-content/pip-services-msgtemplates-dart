import 'package:pip_services3_commons/pip_services3_commons.dart';

class MessageTemplateV1Schema extends ObjectSchema {
  MessageTemplateV1Schema() : super() {
    withOptionalProperty('id', TypeCode.String);
    withRequiredProperty('name', TypeCode.String);
    withOptionalProperty('from', TypeCode.String);
    withRequiredProperty('subject', TypeCode.Map);
    withRequiredProperty('text', TypeCode.Map);
    withOptionalProperty('html', TypeCode.Map);
    withOptionalProperty('status', TypeCode.String);
  }
}
