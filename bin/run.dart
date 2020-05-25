import 'package:pip_services_msgtemplates/pip_services_msgtemplates.dart';

void main(List<String> argument) {
  try {
    var proc = MessageTemplatesProcess();
    proc.configPath = './config/config.yml';
    proc.run(argument);
  } catch (ex) {
    print(ex);
  }
}
