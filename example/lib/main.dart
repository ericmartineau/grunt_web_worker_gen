import 'package:flutter/cupertino.dart';
import 'package:grunt_gen_example/ancient_task.dart';
import 'package:sunny_services/upload_large_file.dart';

import 'ancient_task.dart';
import 'ancient_task.grunt.dart' as g;
import 'test_work_proxies.dart';

// import 'long_task_platform.dart' if (dart.library.js) 'long_task.dart';

var taskMain = g.main;
AncientTask t = AncientTask();
UploadLargeFile f = UploadLargeFile();

AncientTask newAncientTask() => AncientTask();
UploadLargeFile newUploadLargeFile() => UploadLargeFile();
Future main() async {
  // var _dorker = DorkerWorker(
  //     Worker('packages/worker_service_example/long_task.dart.lib.js'));
  // _dorker.onMessage.listen((data_from_worker) => print(data_from_worker));
  // _dorker.postMessage.add('Start working!');

  // if (true == false) {
  //   initializeLongTask();
  // }
  // var e = IsolateEntry(
  //     entryFunction: doStuff,
  //     entryFileName: "packages/worker_service_example/long_task.dart.lib.js");
  // var proxy = await spawnWorkProxy(e, "Bob");
  // proxy.sendToIsolate("Hello");
  runApp(TestWorkProxies());
}
