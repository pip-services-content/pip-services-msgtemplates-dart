import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../src/data/version1/MessageTemplateV1.dart';

abstract class IMessageTemplatesController {
  /// Gets a page of templates retrieved by a given filter.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items
  /// - [paging]            (optional) paging parameters
  /// Return         Future that receives a data page
  /// Throws error.
  Future<DataPage<MessageTemplateV1>> getTemplates(
      String correlationId, FilterParams filter, PagingParams paging);

  /// Gets a template by its unique id.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of template to be retrieved.
  /// Return         Future that receives template or error.
  Future<MessageTemplateV1> getTemplateById(String correlationId, String id);

  /// Gets a template by its unique id or name.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [idOrName]                an unique id or name of template to be retrieved.
  /// Return         Future that receives template or error.
  Future<MessageTemplateV1> getTemplateByIdOrName(
      String correlationId, String idOrName);

  /// Creates a template.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [template]              an template to be created.
  /// Return         (optional) Future that receives created template or error.
  Future<MessageTemplateV1> createTemplate(
      String correlationId, MessageTemplateV1 template);

  /// Updates a template.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [template]              an template to be updated.
  /// Return         (optional) Future that receives updated template
  /// Throws error.
  Future<MessageTemplateV1> updateTemplate(
      String correlationId, MessageTemplateV1 template);

  /// Deleted a template by it's unique id.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of the template to be deleted
  /// Return                Future that receives deleted template
  /// Throws error.
  Future<MessageTemplateV1> deleteTemplateById(
      String correlationId, String templateId);
}
