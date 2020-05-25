import 'dart:async';
import 'package:mongo_dart_query/mongo_dart_query.dart' as mngquery;
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_mongodb/pip_services3_mongodb.dart';

import '../data/version1/MessageTemplateV1.dart';
import './IMessageTemplatesPersistence.dart';

class MessageTemplatesMongoDbPersistence
    extends IdentifiableMongoDbPersistence<MessageTemplateV1, String>
    implements IMessageTemplatesPersistence {
  MessageTemplatesMongoDbPersistence() : super('msgtemplates') {
    maxPageSize = 1000;
  }

  dynamic composeFilter(FilterParams filter) {
    filter = filter ?? FilterParams();

    var criteria = [];

    var search = filter.getAsNullableString('search');
    if (search != null) {
      var searchRegex = RegExp(r'^' + search, caseSensitive: false);
      var searchCriteria = [];
      searchCriteria.add({
        'name': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'status': {r'$regex': searchRegex.pattern}
      });

      searchCriteria.add({
        'subject.en': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'subject.sp': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'subject.fr': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'subject.de': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'subject.ru': {r'$regex': searchRegex.pattern}
      });

      searchCriteria.add({
        'text.en': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'text.sp': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'text.fr': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'text.de': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'text.ru': {r'$regex': searchRegex.pattern}
      });

      searchCriteria.add({
        'html.en': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'html.sp': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'html.fr': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'html.de': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'html.ru': {r'$regex': searchRegex.pattern}
      });
      criteria.add({r'$or': searchCriteria});
    }

    var id = filter.getAsNullableString('id');
    if (id != null) {
      criteria.add({'_id': id});
    }

    var name = filter.getAsNullableString('name');
    if (name != null) {
      criteria.add({'name': name});
    }

    var status = filter.getAsNullableString('status');
    if (status != null) {
      criteria.add({'status': status});
    }

    return criteria.isNotEmpty ? {r'$and': criteria} : null;
  }

  @override
  Future<DataPage<MessageTemplateV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging) async {
    return super
        .getPageByFilterEx(correlationId, composeFilter(filter), paging, null);
  }

  @override
  Future<MessageTemplateV1> getOneByIdOrName(
      String correlationId, String idOrName) async {
    var filter = {
      r'$or': [
        {'_id': idOrName},
        {'name': idOrName}
      ]
    };
    var query = mngquery.SelectorBuilder();
    var selector = <String, dynamic>{};
    if (filter != null && filter.isNotEmpty) {
      selector[r'$query'] = filter;
    }
    query.raw(selector);

    var item = await collection.findOne(selector);

    if (item == null) {
      var err = NotFoundException(correlationId, 'TEMPLATE_NOT_FOUND',
              'Message template ' + idOrName + ' was not found')
          .withDetails('id_or_name', idOrName);
      logger.trace(correlationId, 'Nothing found from %s with idOrName = %s',
          [collectionName, err]);
      return null;
    }
    logger.trace(correlationId, 'Retrieved from %s with idOrName = %s',
        [collectionName, idOrName]);
    return convertToPublic(item);
  }
}
