import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../../src/data/version1/MessageTemplateV1Schema.dart';
import '../../src/logic/IMessageTemplatesController.dart';
import '../../src/data/version1/MessageTemplateV1.dart';

class MessageTemplatesCommandSet extends CommandSet {
  IMessageTemplatesController _controller;

  MessageTemplatesCommandSet(IMessageTemplatesController controller) : super() {
    _controller = controller;

    addCommand(_makeGetMessageTemplatesCommand());
    addCommand(_makeGetMessageTemplateByIdCommand());
    addCommand(_makeGetMessageTemplateByIdOrNameCommand());
    addCommand(_makeCreateMessageTemplateCommand());
    addCommand(_makeUpdateMessageTemplateCommand());
    addCommand(_makeDeleteMessageTemplateByIdCommand());
  }

  ICommand _makeGetMessageTemplatesCommand() {
    return Command(
        'get_templates',
        ObjectSchema(true)
            .withOptionalProperty('filter', FilterParamsSchema())
            .withOptionalProperty('paging', PagingParamsSchema()),
        (String correlationId, Parameters args) {
      var filter = FilterParams.fromValue(args.get('filter'));
      var paging = PagingParams.fromValue(args.get('paging'));
      return _controller.getTemplates(correlationId, filter, paging);
    });
  }

  ICommand _makeGetMessageTemplateByIdCommand() {
    return Command('get_template_by_id',
        ObjectSchema(true).withRequiredProperty('template_id', TypeCode.String),
        (String correlationId, Parameters args) {
      var templateId = args.getAsString('template_id');
      return _controller.getTemplateById(correlationId, templateId);
    });
  }

  ICommand _makeGetMessageTemplateByIdOrNameCommand() {
    return Command('get_template_by_id_or_name',
        ObjectSchema(true).withRequiredProperty('id_or_name', TypeCode.String),
        (String correlationId, Parameters args) {
      var idOrName = args.getAsString('id_or_name');
      return _controller.getTemplateByIdOrName(correlationId, idOrName);
    });
  }

  ICommand _makeCreateMessageTemplateCommand() {
    return Command(
        'create_template',
        ObjectSchema(true)
            .withRequiredProperty('template', MessageTemplateV1Schema()),
        (String correlationId, Parameters args) {
      var template = MessageTemplateV1();
      template.fromJson(args.get('template'));
      return _controller.createTemplate(correlationId, template);
    });
  }

  ICommand _makeUpdateMessageTemplateCommand() {
    return Command(
        'update_template',
        ObjectSchema(true)
            .withRequiredProperty('template', MessageTemplateV1Schema()),
        (String correlationId, Parameters args) {
      var template = MessageTemplateV1();
      template.fromJson(args.get('template'));
      return _controller.updateTemplate(correlationId, template);
    });
  }

  ICommand _makeDeleteMessageTemplateByIdCommand() {
    return Command('delete_template_by_id',
        ObjectSchema(true).withRequiredProperty('template_id', TypeCode.String),
        (String correlationId, Parameters args) {
      var templateId = args.getAsString('template_id');
      return _controller.deleteTemplateById(correlationId, templateId);
    });
  }
}
