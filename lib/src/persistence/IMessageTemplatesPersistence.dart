import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../data/version1/MessageTemplateV1.dart';

abstract class IMessageTemplatesPersistence {
  Future<DataPage<MessageTemplateV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging);

  Future<MessageTemplateV1> getOneById(String correlationId, String id);

  Future<MessageTemplateV1> getOneByIdOrName(
      String correlationId, String idOrName);

  Future<MessageTemplateV1> create(
      String correlationId, MessageTemplateV1 item);

  Future<MessageTemplateV1> update(
      String correlationId, MessageTemplateV1 item);

  Future<MessageTemplateV1> deleteById(String correlationId, String id);
}
