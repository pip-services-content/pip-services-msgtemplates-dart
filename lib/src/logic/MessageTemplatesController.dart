import 'dart:async';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../src/data/version1/MessageTemplateV1.dart';
import '../../src/data/version1/MessageTemplateStatusV1.dart';
import '../../src/persistence/IMessageTemplatesPersistence.dart';
import './IMessageTemplatesController.dart';
import './MessageTemplatesCommandSet.dart';

class MessageTemplatesController
    implements
        IMessageTemplatesController,
        IConfigurable,
        IReferenceable,
        ICommandable {
  static final ConfigParams _defaultConfig = ConfigParams.fromTuples([
    'dependencies.persistence',
    'pip-services-msgtemplates:persistence:*:*:1.0'
  ]);
  IMessageTemplatesPersistence persistence;
  MessageTemplatesCommandSet commandSet;
  DependencyResolver dependencyResolver =
      DependencyResolver(MessageTemplatesController._defaultConfig);

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    dependencyResolver.configure(config);
  }

  /// Set references to component.
  ///
  /// - [references]    references parameters to be set.
  @override
  void setReferences(IReferences references) {
    dependencyResolver.setReferences(references);
    persistence = dependencyResolver
        .getOneRequired<IMessageTemplatesPersistence>('persistence');
  }

  /// Gets a command set.
  ///
  /// Return Command set
  @override
  CommandSet getCommandSet() {
    commandSet ??= MessageTemplatesCommandSet(this);
    return commandSet;
  }

  /// Gets a page of templates retrieved by a given filter.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items
  /// - [paging]            (optional) paging parameters
  /// Return         Future that receives a data page
  /// Throws error.
  @override
  Future<DataPage<MessageTemplateV1>> getTemplates(
      String correlationId, FilterParams filter, PagingParams paging) {
    return persistence.getPageByFilter(correlationId, filter, paging);
  }

  /// Gets a template by its unique id.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of template to be retrieved.
  /// Return         Future that receives template or error.
  @override
  Future<MessageTemplateV1> getTemplateById(String correlationId, String id) {
    return persistence.getOneById(correlationId, id);
  }

  /// Gets a template by its unique id or name.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [idOrName]                an unique id or name of template to be retrieved.
  /// Return         Future that receives template or error.
  @override
  Future<MessageTemplateV1> getTemplateByIdOrName(
      String correlationId, String idOrName) {
    return persistence.getOneByIdOrName(correlationId, idOrName);
  }

  /// Creates a template.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [template]              an template to be created.
  /// Return         (optional) Future that receives created template or error.
  @override
  Future<MessageTemplateV1> createTemplate(
      String correlationId, MessageTemplateV1 template) async {
    template.id = template.id ?? IdGenerator.nextLong();
    template.status = template.status ?? MessageTemplateStatusV1.New;

    return persistence.create(correlationId, template);
  }

  /// Updates a template.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [template]              an template to be updated.
  /// Return         (optional) Future that receives updated template
  /// Throws error.
  @override
  Future<MessageTemplateV1> updateTemplate(
      String correlationId, MessageTemplateV1 template) async {
    template.status = template.status ?? MessageTemplateStatusV1.New;

    return persistence.update(correlationId, template);
  }

  /// Deleted a template by it's unique id.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of the template to be deleted
  /// Return                Future that receives deleted template
  /// Throws error.
  @override
  Future<MessageTemplateV1> deleteTemplateById(
      String correlationId, String id) async {
    return persistence.deleteById(correlationId, id);
  }
}
