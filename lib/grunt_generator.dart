import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:worker_service/work/annotations.dart';

String? fieldName(Element element) {
  return element.name;
}

class GruntGenerator extends GeneratorForAnnotation<grunt> {
  @override
  dynamic generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    try {
      assert(element is ClassElement, "@grunt must only be applied to class");
      final cls = element as ClassElement;
      final logLevel = annotation.read("logLevel").stringValue;
      final logOutput = annotation.read("logOutput").stringValue;
      var mixin = <String>[];
      mixin += [
        "",
        "import 'package:logging/logging.dart';",
        "import 'package:logging_config/logging_config.dart';",
        "import 'package:worker_service/work_in_ww.dart';",
        "import '${buildStep.inputId.uri}';",
        "",
        "final _log = Logger(\"grunt${cls.name}\");",
        "void main() async {",
        "  await configureLogging(LogConfig.root(Level.$logLevel, handler: LoggingHandler.$logOutput()));",
        "  _log.info('Configured logging: $logLevel, $logOutput');",
        "  var channel = GruntChannel.create(${cls.name}());",
        "  await channel.done;",
        '  _log.info("Job ${cls.name} is done");',
        "}",
      ];
      return mixin.join("\n");
    } catch (e) {
      print(e);
    }
  }

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    return super.generate(library, buildStep);
  }
}
