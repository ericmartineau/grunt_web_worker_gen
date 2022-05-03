// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// GruntGenerator
// **************************************************************************

import 'package:logging/logging.dart';
import 'package:logging_config/logging_config.dart';
import 'package:worker_service/work_in_ww.dart';
import 'package:grunt_gen_example/ancient_task.dart';

final _log = Logger("gruntAncientTask");
void main() async {
  configureLogging(LogConfig.root(Level.INFO, handler: LoggingHandler.dev()));
  var channel = GruntChannel.create(AncientTask());
  await channel.done;
  _log.info("Job AncientTask is done");
}
