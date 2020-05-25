import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_data/pip_services3_data.dart';
import '../data/version1/MessageTemplateV1.dart';
import './IMessageTemplatesPersistence.dart';

class MessageTemplatesMemoryPersistence
    extends IdentifiableMemoryPersistence<MessageTemplateV1, String>
    implements IMessageTemplatesPersistence {
  MessageTemplatesMemoryPersistence() : super() {
    maxPageSize = 1000;
  }

  bool matchString(String value, String search) {
    if (value == null && search == null) {
      return true;
    }
    if (value == null || search == null) {
      return false;
    }
    return value.toLowerCase().contains(search);
  }

  bool matchMultilanguageString(dynamic value, String search) {
    for (var prop in value) {
      if (value.hasOwnProperty(prop)) {
        var text = '' + value[prop];
        if (matchString(text, search)) {
          return true;
        }
      }
    }

    return false;
  }

  bool matchSearch(MessageTemplateV1 item, String search) {
    search = search.toLowerCase();
    if (matchString(item.name, search)) {
      return true;
    }
    if (matchMultilanguageString(item.subject, search)) {
      return true;
    }
    if (matchMultilanguageString(item.text, search)) {
      return true;
    }
    if (matchMultilanguageString(item.html, search)) {
      return true;
    }
    if (matchString(item.status, search)) {
      return true;
    }
    return false;
  }

  bool contains(List<String> array1, List<String> array2) {
    if (array1 == null || array2 == null) return false;

    for (var i1 = 0; i1 < array1.length; i1++) {
      for (var i2 = 0; i2 < array2.length; i2++) {
        if (array1[i1] == array2[i2]) {
          return true;
        }
      }
    }

    return false;
  }

  Function composeFilter(FilterParams filter) {
    filter = filter ?? FilterParams();

    var search = filter.getAsNullableString('search');
    var id = filter.getAsNullableString('id');
    var status = filter.getAsNullableString('status');
    var name = filter.getAsNullableString('name');

    return (item) {
      if (search != null && !matchSearch(item, search)) {
        return false;
      }
      if (id != null && item.id != id) {
        return false;
      }
      if (status != null && item.status != status) {
        return false;
      }
      if (name != null && item.name != name) {
        return false;
      }
      return true;
    };
  }

  @override
  Future<DataPage<MessageTemplateV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging) {
    return super
        .getPageByFilterEx(correlationId, composeFilter(filter), paging, null);
  }

  @override
  Future<MessageTemplateV1> getOneByIdOrName(
      String correlationId, String idOrName) async {
    var item = items.isNotEmpty
        ? items.where((item) => item.id == idOrName || item.name == idOrName)
        : null;

    if (item != null && item.isNotEmpty && item.first != null) {
      logger.trace(correlationId, 'Found item by %s', [idOrName]);
      return item.first;
    } else {
      var err = NotFoundException(correlationId, 'TEMPLATE_NOT_FOUND',
              'Message template ' + idOrName + ' was not found')
          .withDetails('id_or_name', idOrName);
      logger.trace(correlationId, 'Cannot find item by %s', [err]);
      return null;
    }
  }
}
