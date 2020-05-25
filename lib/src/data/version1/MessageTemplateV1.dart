import 'package:pip_services3_commons/pip_services3_commons.dart';

class MessageTemplateV1 implements IStringIdentifiable {
  @override
  String id;
  String name;
  String from;
  MultiString subject;
  MultiString text;
  MultiString html;
  String status;

  MessageTemplateV1(
      {String id,
      String name,
      String from,
      MultiString subject,
      MultiString text,
      MultiString html,
      String status})
      : id = id,
        name = name,
        from = from,
        subject = subject,
        text = text,
        html = html,
        status = status;

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    from = json['from'];
    subject = MultiString.fromJson(json['subject']);
    text = MultiString.fromJson(json['text']);
    html = MultiString.fromJson(json['html']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'from': from,
      'subject': subject,
      'text': text,
      'html': html,
      'status': status
    };
  }
}
